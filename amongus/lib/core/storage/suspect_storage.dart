import 'package:hive_flutter/hive_flutter.dart';

import '../../features/home/avatar_option.dart';

class SuspectStorage {
  static const _boxName = 'suspects';

  Box<dynamic> get _box => Hive.box(_boxName);

  bool isSuspect(String username) {
    return _box.containsKey(_key(username));
  }

  Future<void> markSuspect({
    required String username,
    required AvatarOption avatar,
  }) async {
    await _box.put(_key(username), {
      'username': username,
      'avatar': avatar.apiValue,
      'markedAt': DateTime.now().toIso8601String(),
    });
  }

  static String _key(String username) => username.trim().toLowerCase();
}
