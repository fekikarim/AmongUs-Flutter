import 'package:flutter/material.dart';

import '../../app/assets.dart';

enum AvatarOption {
  red(
    apiValue: 'red',
    assetPath: AppAssets.avatarRed,
    swatchColor: Colors.red,
    displayName: 'Red',
  ),
  yellow(
    apiValue: 'yellow',
    assetPath: AppAssets.avatarYellow,
    swatchColor: Colors.yellow,
    displayName: 'Yellow',
  ),
  brown(
    apiValue: 'brown',
    assetPath: AppAssets.avatarBrown,
    swatchColor: Colors.brown,
    displayName: 'Brown',
  ),
  lightBlue(
    apiValue: 'blue',
    assetPath: AppAssets.avatarLightBlue,
    swatchColor: Colors.lightBlue,
    displayName: 'Blue',
  ),
  orange(
    apiValue: 'orange',
    assetPath: AppAssets.avatarOrange,
    swatchColor: Colors.orange,
    displayName: 'Orange',
  ),
  purple(
    apiValue: 'purple',
    assetPath: AppAssets.avatarPurple,
    swatchColor: Colors.purple,
    displayName: 'Purple',
  ),
  rose(
    apiValue: 'rose',
    assetPath: AppAssets.avatarRose,
    swatchColor: Colors.pink,
    displayName: 'Rose',
  );

  const AvatarOption({
    required this.apiValue,
    required this.assetPath,
    required this.swatchColor,
    required this.displayName,
  });

  final String apiValue;
  final String assetPath;
  final Color swatchColor;
  final String displayName;

  static AvatarOption fromApiValue(String value) {
    return AvatarOption.values.firstWhere(
      (e) => e.apiValue == value,
      orElse: () => AvatarOption.red,
    );
  }
}
