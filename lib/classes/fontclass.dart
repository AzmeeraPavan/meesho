import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Color.fromARGB(126, 152, 37, 187);
  static const Color secondaryColor = Color(0xFF1C1C1E);
  static const Color accentColor = Color(0xFFFFC107);
  static const Color textColor = Colors.black87;
  static const Color hintColor = Colors.grey;

  // ===========================
  // Font Families
  // ===========================
  static const String fontPrimary = 'Roboto';
  static const String fontSecondary = 'Montserrat';

  // ===========================
  // Font Sizes
  // ===========================
  static const double heading1 = 32;
  static const double heading2 = 24;
  static const double heading3 = 20;
  static const double body = 16;
  static const double small = 12;

  // ===========================
  // Text Styles
  // ===========================
  static TextStyle heading1Style({
    Color color = textColor,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontFamily: fontPrimary,
      fontSize: heading1,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle heading2Style({
    Color color = textColor,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontFamily: fontPrimary,
      fontSize: heading2,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle heading3Style({
    Color color = textColor,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontFamily: fontPrimary,
      fontSize: heading3,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle bodyStyle({
    Color color = textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontFamily: fontPrimary,
      fontSize: body,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle smallStyle({
    Color color = hintColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontFamily: fontSecondary,
      fontSize: small,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: heading2Style(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
