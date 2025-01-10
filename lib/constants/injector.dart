import 'package:to_do_task_app/helper/hive_db_helper.dart';

class Injector {
  static Injector? _instance;
  static bool isDarkMode = false;

  factory Injector() {
    return _instance ?? Injector._internal();
  }

  Injector._internal() {
    _instance = this;
  }

  static Injector get shared => Injector();

  static getInstance() async {
    if (HiveDbHelper.userData?.isLightTheme == null || (HiveDbHelper.userData?.isLightTheme ?? false)) {
      isDarkMode = false;
    } else {
      isDarkMode = true;
    }
  }
}
