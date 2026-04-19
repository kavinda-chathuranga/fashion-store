import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF1E112A); // Deep Royal Purple
  static const Color accentColor = Color(0xFFD6A054); // Elegant Gold
  static const Color backgroundColor = Color(0xFFF8F8F8); // Off-white luxury
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF757575);
  static const Color errorColor = Color(0xFFE57373);

  // Light Theme
  static ThemeData get lightTheme {
    return _baseTheme(Brightness.light);
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return _baseTheme(Brightness.dark);
  }

  static ThemeData _baseTheme(Brightness brightness) {
    bool isDark = brightness == Brightness.dark;
    Color scaffoldBg = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF0F0F0);
    Color cardCol = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color textCol = isDark ? Colors.white : const Color(0xFF1A1A1A);
    Color subTextCol = isDark ? Colors.grey.shade400 : const Color(0xFF757575);

    return ThemeData(
      brightness: brightness,
      primaryColor: isDark ? const Color(0xFFD2BCA8) : primaryColor,
      scaffoldBackgroundColor: scaffoldBg,
      cardColor: cardCol,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: isDark ? const Color(0xFFD2BCA8) : primaryColor,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: accentColor,
        onSecondary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        surface: cardCol,
        onSurface: textCol,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textCol),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: textCol,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white10 : Colors.black12,
        thickness: 1,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textCol,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textCol,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: textCol),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: subTextCol),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: subTextCol),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFFD2BCA8) : primaryColor,
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardCol,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: subTextCol),
        hintStyle: GoogleFonts.inter(color: subTextCol.withOpacity(0.5)),
      ),
    );
  }
}

// Extension to easily access custom theme colors
extension ThemeExtras on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  Color get headerColor =>
      isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFE5D9CC);
  Color get beigeColor => const Color(0xFFD2BCA8);
  Color get cardColor => Theme.of(this).cardColor;
  Color get textColor =>
      Theme.of(this).textTheme.bodyLarge?.color ?? Colors.black;
  Color get subTextColor =>
      Theme.of(this).textTheme.bodyMedium?.color ?? Colors.grey;
}
