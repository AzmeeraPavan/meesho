import 'package:flutter/widgets.dart';

class Responsive {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  static bool get isMobile => screenWidth < 500;
  static bool get isTablet => screenWidth > 500 && screenWidth < 950;
  static bool get isDesktop => screenWidth >= 950;

  static double width(double percent) => screenWidth * percent / 100;
  static double height(double percent) => screenHeight * percent / 100;
}
