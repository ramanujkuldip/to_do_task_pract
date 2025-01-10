import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/injector.dart';
import 'helper/hive_db_helper.dart';
import 'helper/sql_db_helper.dart';
import 'view/login_module/login_view.dart';
import 'view/tasks_list_module/tasks_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDbHelper.initHive();
  DatabaseHelper.instance.initDb();

  Injector.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: HiveDbHelper.userData?.isLightTheme ?? true
          ? ThemeMode.light
          : ThemeMode.dark,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: HiveDbHelper.userData != null
          ? const TasksListView()
          : const LoginView(),
    );
  }
}
