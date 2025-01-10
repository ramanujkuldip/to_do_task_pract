import 'package:flutter/material.dart';

import '../../constants/utils.dart';

class BaseDropDown extends DropdownButtonFormField {
  final String value;
  final String title;
  final List items;
  final Function(String) onTap;

  BaseDropDown({
    required this.value,
    required this.title,
    required this.items,
    required this.onTap,
    super.key,
  }) : super(
          decoration: InputDecoration(
            labelText: title,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(Utils.capitalize(item)),
            );
          }).toList(),
          onChanged: (value) => onTap(value!),
        );
}
