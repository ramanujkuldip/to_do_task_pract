import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/injector.dart';

class BaseButton extends ElevatedButton {
  final Function() onTap;
  final String buttonText;

  BaseButton({required this.onTap, required this.buttonText})
      : super(
          onPressed: onTap,
          style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(
                Size(MediaQuery.of(Get.context!).size.height, 52)),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white),
          ),
        );
}
