import 'package:flutter/material.dart';

class AppColors {
  static const primaryGreen = Color(0xFF075E54);
  static const tealGreen = Color(0xFF128C7E);
  static const lightGreen = Color(0xFF25D366);
  static const chatBackground = Color(0xFFECE5DD);
  static const bubbleMe = Color(0xFFDCF8C6);
  static const bubbleOther = Color(0xFFFFFFFF);
  static const appBarText = Colors.white;
  static const unreadBadge = Color(0xFF25D366);
  static const dividerGrey = Color(0xFFE0E0E0);
  static const subtitleGrey = Color(0xFF667781);
  static const tickBlue = Color(0xFF34B7F1);

  static const avatarPalette = <Color>[
    Color(0xFFEF9A9A),
    Color(0xFF90CAF9),
    Color(0xFFA5D6A7),
    Color(0xFFFFCC80),
    Color(0xFFCE93D8),
    Color(0xFF80CBC4),
    Color(0xFFB0BEC5),
  ];

  static Color avatarColorFor(String seed) {
    final index = seed.codeUnits.fold<int>(0, (a, b) => a + b) %
        avatarPalette.length;
    return avatarPalette[index];
  }
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.primaryGreen,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.appBarText,
      elevation: 0,
      centerTitle: false,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.tealGreen,
      primary: AppColors.tealGreen,
    ),
    fontFamily: 'Roboto',
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xFFB2DFDB),
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
  );
}
