import 'package:flutter/material.dart';

class BaseTextFiled extends TextFormField {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final Function()? onTap;

  BaseTextFiled({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.readOnly,
    this.validator,
    this.onTap,
  }) : super(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          readOnly: readOnly ?? false,
          onTap: onTap,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            hintStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: validator != null ? (value) => validator(value) : null,
        );
}
