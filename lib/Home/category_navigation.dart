// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  final String text;
  const CenterText(this.text);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(children: [Text(text)]),
      ],
    );
  }
}
