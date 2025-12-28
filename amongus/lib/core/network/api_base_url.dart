import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

String getApiBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:3000';
  }

  if (Platform.isAndroid) {
    // Android emulator maps host loopback to 10.0.2.2
    return 'http://10.0.2.2:3000';
  }

  // iOS Simulator / macOS / Windows / Linux
  return 'http://localhost:3000';
}
