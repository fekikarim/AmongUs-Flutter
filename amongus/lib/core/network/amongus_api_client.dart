import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_base_url.dart';

class AmongUsApiClient {
  AmongUsApiClient({http.Client? httpClient})
    : _http = httpClient ?? http.Client(),
      _baseUrl = Uri.parse(getApiBaseUrl());

  final http.Client _http;
  final Uri _baseUrl;

  Future<String> addPlayer({
    required String avatar,
    required String username,
  }) async {
    final uri = _baseUrl.replace(path: '/addplayer');

    final response = await _http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'avatar': avatar, 'username': username}),
    );

    if (response.statusCode != 200) {
      throw ApiException('Add player failed', statusCode: response.statusCode);
    }

    final json = jsonDecode(response.body);
    final token = json is Map<String, dynamic> ? json['access_token'] : null;
    if (token is! String || token.isEmpty) {
      throw ApiException(
        'Invalid token response',
        statusCode: response.statusCode,
      );
    }

    return token;
  }

  Future<RoomDto> getRoom({required String accessToken}) async {
    final uri = _baseUrl.replace(path: '/room');

    final response = await _http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    );

    if (response.statusCode != 200) {
      throw ApiException('Get room failed', statusCode: response.statusCode);
    }

    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic>) {
      throw ApiException(
        'Invalid room response',
        statusCode: response.statusCode,
      );
    }

    return RoomDto.fromJson(json);
  }
}

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}

class RoomDto {
  RoomDto({required this.name, required this.players});

  final String name;
  final List<PlayerDto> players;

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final players = json['players'];

    return RoomDto(
      name: name is String ? name : 'Room',
      players: players is List
          ? players
                .whereType<Map>()
                .map((e) => PlayerDto.fromJson(e.cast<String, dynamic>()))
                .toList()
          : const [],
    );
  }
}

class PlayerDto {
  PlayerDto({
    required this.avatar,
    required this.username,
    required this.votes,
  });

  final String avatar;
  final String username;
  final int votes;

  factory PlayerDto.fromJson(Map<String, dynamic> json) {
    final avatar = json['avatar'];
    final username = json['username'];
    final votes = json['votes'];

    return PlayerDto(
      avatar: avatar is String ? avatar : 'red',
      username: username is String ? username : 'Player',
      votes: votes is int ? votes : 0,
    );
  }
}
