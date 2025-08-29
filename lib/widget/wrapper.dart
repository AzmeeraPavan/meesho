import 'package:flutter/material.dart';

class ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const ResponsiveWrap({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define breakpoints for mobile, tablet, desktop
        final width = constraints.maxWidth;

        // Mobile breakpoint example: width < 650
        if (width < 650) {
          // On mobile, stack children vertically in a Column (filters on top)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        } else {
          // On tablet or desktop: use Wrap with spacing (side by side with wrapping)
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: WrapAlignment.start,
            children: children,
          );
        }
      },
    );
  }
}
