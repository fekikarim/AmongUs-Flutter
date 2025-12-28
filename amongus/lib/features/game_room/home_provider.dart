import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../core/network/amongus_api_client.dart';

enum VotesSortOrder { none, asc, desc }

class HomeProvider extends ChangeNotifier {
  HomeProvider({
    required AmongUsApiClient apiClient,
    required String accessToken,
  }) : _api = apiClient,
       _accessToken = accessToken;

  final AmongUsApiClient _api;
  final String _accessToken;

  final StreamController<UnmodifiableListView<PlayerDto>> _playersController =
      StreamController<UnmodifiableListView<PlayerDto>>.broadcast();

  Stream<UnmodifiableListView<PlayerDto>> get playersStream =>
      _playersController.stream;

  bool _isLoading = false;
  String? _error;
  String _roomName = '';
  VotesSortOrder _sortOrder = VotesSortOrder.none;
  final List<PlayerDto> _players = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get roomName => _roomName;
  VotesSortOrder get sortOrder => _sortOrder;

  UnmodifiableListView<PlayerDto> get players => UnmodifiableListView(_players);

  Future<void> loadRoom() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final room = await _api.getRoom(accessToken: _accessToken);
      _roomName = room.name;

      _players
        ..clear()
        ..addAll(room.players);

      _applyCurrentSort();
      _emitPlayers();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Failed to load room';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleVotesSort() {
    switch (_sortOrder) {
      case VotesSortOrder.none:
      case VotesSortOrder.desc:
        sortByVotesAsc();
        break;
      case VotesSortOrder.asc:
        sortByVotesDesc();
        break;
    }
  }

  void sortByVotesAsc() {
    _sortOrder = VotesSortOrder.asc;
    _players.sort((a, b) => a.votes.compareTo(b.votes));
    _emitPlayers();
    notifyListeners();
  }

  void sortByVotesDesc() {
    _sortOrder = VotesSortOrder.desc;
    _players.sort((a, b) => b.votes.compareTo(a.votes));
    _emitPlayers();
    notifyListeners();
  }

  void clearSort() {
    _sortOrder = VotesSortOrder.none;
    // No stable “original order” is available from backend, so keep current.
    _emitPlayers();
    notifyListeners();
  }

  void _applyCurrentSort() {
    switch (_sortOrder) {
      case VotesSortOrder.asc:
        _players.sort((a, b) => a.votes.compareTo(b.votes));
        break;
      case VotesSortOrder.desc:
        _players.sort((a, b) => b.votes.compareTo(a.votes));
        break;
      case VotesSortOrder.none:
        break;
    }
  }

  void _emitPlayers() {
    if (_playersController.isClosed) return;
    _playersController.add(UnmodifiableListView<PlayerDto>(_players));
  }

  @override
  void dispose() {
    _playersController.close();
    super.dispose();
  }
}
