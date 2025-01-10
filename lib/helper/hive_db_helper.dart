import 'package:hive_flutter/hive_flutter.dart';

import '../constants/constants.dart';
import '../model/user_model.dart';

class HiveDbHelper {
  static final userBox = Hive.box(StringRes.userPrefs);
  static UserModel? _userData;

  static UserModel? get userData => _userData;

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox(StringRes.userPrefs);
    _userData = getUser();
  }

  static registerUser(UserModel userData) {
    userBox.put(StringRes.userPrefs, userData);
    getUser();
  }

  static updateUser(UserModel userData) {
    userBox.put(StringRes.userPrefs, userData);
    return getUser();
  }

  static getUser() {
    _userData = userBox.get(StringRes.userPrefs);
    return userData;
  }

  static deleteUser(String key) {
    return userBox.delete(key);
  }

  static closeBox() {
    userBox.close();
  }
}
