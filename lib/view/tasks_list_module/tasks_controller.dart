import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/enums.dart';
import '../../constants/injector.dart';
import '../../helper/hive_db_helper.dart';
import '../../helper/sql_db_helper.dart';
import '../../model/common_model.dart';
import '../../model/task_model.dart';
import '../../model/user_model.dart';

class TasksController extends GetxController {
  final TextEditingController taskNameDialogController =
      TextEditingController();
  final TextEditingController taskDueDateController = TextEditingController();
  final TextEditingController descriptionDialogController =
      TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isShowPending = false.obs;

  RxList<TaskModel> tasksList = <TaskModel>[].obs;

  @override
  void onInit() {
    loadAllTasks();
    super.onInit();
  }

  loadAllTasks({String? sortBy}) async {
    tasksList.value = [];
    isLoading.value = true;
    List dbList = await DatabaseHelper.instance.getAllTasks() as List;

    if (sortBy != null) {
      if (sortBy == SortByDefault.all.name) {
        sortByDate(false);
      } else if (sortBy == SortByDefault.byDueDate.name) {
        sortByDate(true);
      } else {
        filterData(CommonModel(value: sortBy));
      }
    } else {
      for (var e in dbList) {
        tasksList.add(TaskModel.fromMap(e));
      }
    }

    tasksList.value = tasksList.reversed.toList();
    isLoading.value = false;
  }

  filterData(CommonModel value) async {
    tasksList.value = [];
    List dbList = await DatabaseHelper.instance.getAllTasks() as List;
    for (var e in dbList) {
      final data = TaskModel.fromMap(e);
      if (data.priority == value.value) {
        tasksList.add(data);
      }
    }
    tasksList.value = tasksList.reversed.toList();
  }

  sortByStatus() async {
    isShowPending.value = !isShowPending.value;
    if (isShowPending.value) {
      tasksList.sort((a, b) => a.isCompleted!.compareTo(b.isCompleted!));
    } else {
      tasksList.sort((a, b) => b.isCompleted!.compareTo(a.isCompleted!));
    }
  }

  sortByDate(bool isShowByDueDate) async {
    tasksList.value = [];
    List dbList = await DatabaseHelper.instance.getAllTasks() as List;
    for (var e in dbList) {
      final data = TaskModel.fromMap(e);
      tasksList.add(data);
    }
    if (isShowByDueDate) {
      tasksList.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    } else {
      tasksList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    }
    tasksList.value = tasksList.value;
  }

  addNewTask(TaskModel task) {
    DatabaseHelper.instance.insertTask(task);
    tasksList.add(task);
  }

  updateTask(TaskModel task) {
    DatabaseHelper.instance.updateTask(task);
    int i = tasksList.indexWhere((element) => element.id == task.id);
    tasksList[i] = task;
    if (HiveDbHelper.userData?.sortBy == SortByDefault.byDueDate.name) {
      tasksList.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    } else {
      tasksList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    }
    tasksList.value = tasksList.value;
  }

  deleteTask(TaskModel task) {
    DatabaseHelper.instance.deleteTask(task.uuid!);
    tasksList.removeWhere((element) => element.uuid == task.uuid);
  }

  changeTheme() {
    if (Injector.isDarkMode) {
      Injector.isDarkMode = false;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Injector.isDarkMode = true;
      Get.changeThemeMode(ThemeMode.dark);
    }
    HiveDbHelper.updateUser(
      UserModel(
        id: HiveDbHelper.userData?.id,
        isLightTheme: !Injector.isDarkMode,
        username: HiveDbHelper.userData?.username,
        userEmail: HiveDbHelper.userData?.userEmail,
      ),
    );
    update();
  }

  setDefaultSortOrder(String sortBy) {
    HiveDbHelper.updateUser(
      UserModel(
        id: HiveDbHelper.userData?.id,
        isLightTheme: HiveDbHelper.userData?.isLightTheme,
        username: HiveDbHelper.userData?.username,
        userEmail: HiveDbHelper.userData?.userEmail,
        sortBy: sortBy,
      ),
    );
  }

  @override
  void dispose() {
    HiveDbHelper.closeBox();
    super.dispose();
  }

  @override
  void onClose() {
    HiveDbHelper.closeBox();
    super.onClose();
  }
}
