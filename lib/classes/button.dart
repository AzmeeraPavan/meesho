import 'package:flutter/material.dart';

class CommonButton {
  static Widget myButton(
    BuildContext context,
    double width,
    double l,
    double t,
    double r,
    double b,
    VoidCallback? func,
    String text, {
    IconData? icon, // optional icon
    Color borderColor = Colors.purple,
    Color textColor = const Color.fromARGB(255, 179, 71, 212),
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: func,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.fromLTRB(l, t, r, b),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: textColor),
            if (icon != null) const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: func != null ? textColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static MaterialButton mcButton(
    BuildContext context,
    double width,
    double l,
    double t,
    double r,
    double b,
    VoidCallback? func,
    String text, {
    IconData? icon, // optional icon
    bool isSelected = false, // new parameter for selection state
  }) {
    return MaterialButton(
      minWidth: width,
      padding: EdgeInsets.fromLTRB(l, t, r, b),
      onPressed: func,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(
          color: isSelected
              ? const Color.fromARGB(
                  255,
                  226,
                  33,
                  243,
                ) // highlight the selected button border
              : const Color.fromARGB(255, 41, 20, 44),
          width: isSelected ? 2.5 : 1,
        ),
      ),
      color: isSelected
          // ignore: deprecated_member_use
          ? const Color.fromARGB(255, 204, 50, 243).withOpacity(0.2)
          : null, // subtle fill for selected
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: func != null
                  ? (isSelected
                        ? const Color.fromARGB(255, 226, 33, 243)
                        : Color.fromARGB(255, 20, 8, 24))
                  : Colors.white10,
            ),
          if (icon != null) SizedBox(width: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20).copyWith(
              color: func != null
                  ? (isSelected
                        ? const Color.fromARGB(255, 177, 40, 231)
                        : Color.fromARGB(255, 16, 14, 17))
                  : Colors.white10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static MaterialButton filledButton(
    BuildContext context,
    double width,
    double l,
    double t,
    double r,
    double b,
    VoidCallback? func,
    String text, {
    IconData? icon, // optional icon
  }) {
    return MaterialButton(
      minWidth: width,
      padding: EdgeInsets.fromLTRB(l, t, r, b),
      color: func != null
          ? Colors.purple
          : Colors.white10, // greyed out when disabled
      onPressed: func,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: func != null ? Colors.white : Colors.white54),
          if (icon != null) SizedBox(width: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20).copyWith(
              color: func != null ? Colors.white : Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
