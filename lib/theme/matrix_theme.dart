import 'package:flutter/material.dart';

class MatrixTheme {
  // Matrix Color Palette
  static const Color matrixGreen = Color(0xFF00FF00);
  static const Color matrixDarkGreen = Color(0xFF00CC00);
  static const Color matrixBlack = Color(0xFF000000);
  static const Color matrixDarkGray = Color(0xFF333333);
  static const Color matrixLightGray = Color(0xFF666666);
  
  // Text Styles
  static const TextStyle matrixText = TextStyle(
    color: matrixGreen,
    fontFamily: 'Matrix',
    fontSize: 16,
  );
  
  static const TextStyle matrixHeading = TextStyle(
    color: matrixGreen,
    fontFamily: 'Matrix',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle matrixSubheading = TextStyle(
    color: matrixGreen,
    fontFamily: 'Matrix',
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle matrixButton = TextStyle(
    color: matrixBlack,
    fontFamily: 'Matrix',
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  
  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: matrixGreen,
      scaffoldBackgroundColor: matrixBlack,
      appBarTheme: const AppBarTheme(
        backgroundColor: matrixBlack,
        foregroundColor: matrixGreen,
        elevation: 0,
        titleTextStyle: matrixHeading,
      ),
      cardTheme: CardTheme(
        color: matrixDarkGray,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: matrixGreen, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: matrixGreen,
          foregroundColor: matrixBlack,
          textStyle: matrixButton,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: matrixGreen,
          textStyle: matrixText,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: matrixGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: matrixGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: matrixGreen, width: 2),
        ),
        labelStyle: const TextStyle(color: matrixGreen),
        hintStyle: const TextStyle(color: matrixLightGray),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: matrixGreen,
      ),
      dividerTheme: const DividerThemeData(
        color: matrixGreen,
        thickness: 1,
      ),
    );
  }
  
  // Custom Decorations
  static BoxDecoration get matrixCardDecoration {
    return BoxDecoration(
      color: matrixDarkGray,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: matrixGreen, width: 1),
      boxShadow: [
        BoxShadow(
          color: matrixGreen.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    );
  }
  
  static BoxDecoration get matrixButtonDecoration {
    return BoxDecoration(
      color: matrixGreen,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: matrixGreen.withOpacity(0.5),
          blurRadius: 4,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
