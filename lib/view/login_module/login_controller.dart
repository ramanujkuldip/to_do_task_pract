import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../constants/injector.dart';
import '../../helper/hive_db_helper.dart';
import '../../model/user_model.dart';
import '../tasks_list_module/tasks_view.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  createUser() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Uuid uuid = const Uuid();
    final userData = UserModel(
      id: uuid.v4(),
      isLightTheme: true,
      username: userNameController.text.trim(),
      userEmail: emailController.text.trim(),
    );
    HiveDbHelper.registerUser(userData);
    Get.off(const TasksListView());
  }

}
