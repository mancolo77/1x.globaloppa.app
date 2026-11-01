import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF1D4266);
  static const Color darkNav = Color(0xFF245782);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color lightBg = Color(0xFFF0F4F8);
  static const Color border = Color(0xFFD5E0EB);
  static const Color primary = Color(0xFF286DA5);
  static const Color accentGreen = Color(0xFF80AD23);
  static const Color textMain = Color(0xFF203F60);
  static const Color textSecondary = Color(0xFF657D94);
  static const Color textLight = Color(0xFFFFFFFF);

  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double screenPadding = 16.0;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: surfaceCard,
        
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
        ),
      ),
    );
  }

  // Compatibility getters
  static const Color surface = surfaceCard;
  static const Color surfaceElevated = surfaceCard;
  static const Color surfaceBorder = border;
  static const Color textPrimary = textMain;
  static const Color textMuted = textSecondary;
  static const Color secondary = primary;
  static const Color accentYellow = primary;
  static const Color accentGold = primary;
  static const Color accentRose = Color(0xFFED2433);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withAlpha(20),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get neonGlow => [
        BoxShadow(
          color: primary.withAlpha(50),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ];

  static ThemeData get darkTheme => theme;
  static ThemeData get lightTheme => theme;
}
