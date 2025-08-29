// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedOptions.contains(option);

        return CheckboxListTile(
          title: Text(option),
          value: isSelected,
          onChanged: (value) {
            final newSelected = List<String>.from(selectedOptions);
            if (value == true) {
              newSelected.add(option);
            } else {
              newSelected.remove(option);
            }
            onChanged(newSelected);
          },
        );
      },
    );
  }
}
