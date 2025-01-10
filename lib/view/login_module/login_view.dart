import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/base_button.dart';
import '../../widgets/base_textfield.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginController(),
      dispose: (state) => Get.delete<LoginController>(),
      builder: (controller) {
        return Scaffold(
          body: mainBody(
            context,
            controller,
          ),
        );
      },
    );
  }

  SafeArea mainBody(
    BuildContext context,
    LoginController controller,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .15),
              appTitleTextView(),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              loginTextView(),
              const SizedBox(height: 10),
              formView(controller),
              const SizedBox(height: 10),
              getRegisterButton(controller)
            ],
          ),
        ),
      ),
    );
  }

  Text appTitleTextView() {
    return const Text(
      "To Do",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
    );
  }

  Card formView(LoginController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              BaseTextFiled(
                controller: controller.userNameController,
                labelText: 'Username',
                hintText: 'Enter your username',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  if (value.length < 3) {
                    return 'Username must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              BaseTextFiled(
                controller: controller.emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  // Regex for validating email
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton getRegisterButton(
    LoginController controller,
  ) {
    return BaseButton(
      onTap: () {
        controller.createUser();
      },
      buttonText: "Register",
    );
  }

  getTextFormFiled({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) => validator(value),
    );
  }

  Text loginTextView() {
    return const Text(
      "Register User",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.deepPurple,
      ),
    );
  }
}
