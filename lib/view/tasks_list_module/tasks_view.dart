import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../constants/enums.dart';
import '../../constants/utils.dart';
import '../../helper/hive_db_helper.dart';
import '../../model/common_model.dart';
import '../../model/task_model.dart';
import '../../widgets/base_button.dart';
import '../../widgets/base_textfield.dart';
import '../task_details_module/task_details_view.dart';
import 'base_drop_down.dart';
import 'tasks_controller.dart';

class TasksListView extends StatelessWidget {
  const TasksListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TasksController(),
      dispose: (state) => Get.delete<TasksController>(),
      builder: (controller) {
        return Scaffold(
          appBar: getAppBar(controller),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18, left: 18, bottom: 18.0, top: 10),
              child: Column(
                children: [
                  titleAndFiltersView(controller),
                  const SizedBox(height: 20),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        controller.loadAllTasks(
                            sortBy: HiveDbHelper.userData?.sortBy);
                      },
                      child: Obx(
                        () => controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : tasksListView(controller.tasksList, controller),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: bottomNavBarView(context, controller),
        );
      },
    );
  }

  Row titleAndFiltersView(TasksController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "To do tasks",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                controller.sortByStatus();
              },
              child: const Row(
                children: [
                  Text(
                    "Status",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.compare_arrows,
                      color: Colors.deepPurple,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            PopupMenuButton<CommonModel>(
              onSelected: (CommonModel value) {
                if (value.isShowByDate ?? false) {
                  controller.sortByDate(value.value);
                  controller.setDefaultSortOrder(
                    value.value
                        ? SortByDefault.byDueDate.name
                        : SortByDefault.all.name,
                  );
                } else {
                  controller.filterData(value);
                  controller.setDefaultSortOrder(value.value);
                }
              },
              itemBuilder: (BuildContext context) {
                return filerList.map((CommonModel option) {
                  return PopupMenuItem<CommonModel>(
                    value: option,
                    child: Text(option.title ?? ""),
                  );
                }).toList();
              },
              child: const Text(
                "Filter",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  SafeArea bottomNavBarView(BuildContext context, TasksController controller) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: BaseButton(
          onTap: () async {
            showForm(
              context: context,
              controller: controller,
            );
          },
          buttonText: "Add Task",
        ),
      ),
    );
  }

  tasksListView(List<TaskModel> tasks, TasksController controller) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "You haven't any tasks!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        final data = tasks[index];
        return GestureDetector(
          onTap: () {
            Get.to(TaskDetailsView(taskModel: data));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.taskName ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (data.priority != null && data.priority!.isNotEmpty)
                          getPriorityCard(
                            data.priority ?? "",
                          ),
                        if (data.priority != null && data.priority!.isNotEmpty)
                          const SizedBox(width: 5),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                              value: data.isCompleted == 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              visualDensity: VisualDensity.compact,
                              onChanged: (value) {
                                final task = TaskModel(
                                  id: data.id,
                                  taskName: data.taskName,
                                  description: data.description,
                                  priority: data.priority,
                                  dueDate: data.dueDate,
                                  isCompleted: value ?? false ? 1 : 0,
                                  createdAt: data.createdAt,
                                );
                                controller.updateTask(task);
                              }),
                        )
                      ],
                    ),
                  ],
                ),
                if (HiveDbHelper.userData?.sortBy ==
                    SortByDefault.byDueDate.name)
                  Text(
                    "Due Date: ${Utils.convertTimeStampToDateTime(data.dueDate ?? 0)}",
                    style: const TextStyle(fontSize: 10),
                  ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: tasks.length,
    );
  }

  Container getChipCard(
    String title, [
    bool? isTaskCompleted,
  ]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isTaskCompleted ?? false ? Colors.green : Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        Utils.capitalize(title),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Container getPriorityCard(String title) {
    Color bgColor;
    if (TaskPriority.high.name == title.toLowerCase()) {
      bgColor = Colors.deepOrange;
    } else if (TaskPriority.medium.name == title.toLowerCase()) {
      bgColor = Colors.amber;
    } else {
      bgColor = Colors.teal;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        Utils.capitalize(title),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  SizedBox getIconButton({
    required IconData icon,
    Color? iconColor,
    required Function() onTap,
  }) {
    return SizedBox(
      height: 24,
      width: 24,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }

  AppBar getAppBar(TasksController controller) {
    return AppBar(
      leading: const Padding(
        padding: EdgeInsets.only(left: 12),
        child: CircleAvatar(child: Icon(Icons.person)),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            HiveDbHelper.userData?.username ?? "",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            HiveDbHelper.userData?.userEmail ?? "",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: HiveDbHelper.userData?.isLightTheme == false
                  ? Colors.white.withOpacity(.5)
                  : Colors.black54,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            controller.changeTheme();
          },
          icon: Icon(
            HiveDbHelper.userData?.isLightTheme ?? false
                ? Icons.dark_mode
                : Icons.brightness_7,
          ),
        ),
      ],
    );
  }

  static Future<void> showForm({
    TaskModel? taskData,
    required BuildContext context,
    required TasksController controller,
    Function(TaskModel?)? thenCallBack,
  }) async {
    String? selectedValue;
    String? selectedStatus;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    if (taskData != null) {
      controller.taskNameDialogController.text = taskData.taskName ?? '';
      controller.descriptionDialogController.text = taskData.description ?? "";
      controller.taskDueDateController.text =
          Utils.convertTimeStampToDateTime(taskData.dueDate ?? 0);
      selectedValue = taskData.priority;
      selectedStatus = taskData.isCompleted == 0 ? "pending" : "completed";
    } else {
      controller.taskNameDialogController.clear();
      controller.descriptionDialogController.clear();
      controller.taskDueDateController.clear();
      selectedValue = TaskPriority.low.name;
      selectedStatus = "pending";
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  taskData == null ? 'Add New Task' : 'Update Task',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BaseTextFiled(
                  controller: controller.taskNameDialogController,
                  hintText: "Enter task name",
                  labelText: "Task Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Task Name is required';
                    }
                    return null;
                  }),
              const SizedBox(height: 15),
              BaseTextFiled(
                controller: controller.descriptionDialogController,
                hintText: "Enter task description",
                labelText: "Description",
              ),
              const SizedBox(height: 15),
              BaseTextFiled(
                  controller: controller.taskDueDateController,
                  hintText: "Select due date",
                  labelText: "Due Date",
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then(
                      (value) {
                        if (value != null) {
                          controller.taskDueDateController.text =
                              DateFormat("dd/MM/yyyy").format(value);
                        }
                      },
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Due date is required';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: BaseDropDown(
                      title: 'Select Priority',
                      value: selectedValue ?? TaskPriority.low.name,
                      items: const [
                        'high',
                        'medium',
                        'low',
                      ],
                      onTap: (val) {
                        selectedValue = val;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BaseDropDown(
                      title: 'Select Status',
                      value: selectedStatus ?? TaskStatus.pending.name,
                      items: const [
                        'pending',
                        'completed',
                      ],
                      onTap: (val) {
                        selectedStatus = val;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BaseButton(
                onTap: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  final task = TaskModel(
                    id: taskData?.id,
                    taskName: controller.taskNameDialogController.text.trim(),
                    description:
                        controller.descriptionDialogController.text.trim(),
                    priority: selectedValue,
                    dueDate: Utils.convertDateTimeToTimeStamp(
                        controller.taskDueDateController.text),
                    isCompleted:
                        selectedStatus == TaskStatus.completed.name ? 1 : 0,
                    createdAt: taskData?.createdAt,
                  );

                  if (taskData != null) {
                    controller.updateTask(task);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Task updated successfully',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    controller.addNewTask(task);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Task added successfully',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  Get.back(result: task);
                },
                buttonText: taskData != null ? "Update" : "Add",
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    ).then(
      (value) {
        if (thenCallBack != null) {
          thenCallBack(value);
        }
      },
    );
  }

  static void showDeleteDialog(
      TaskModel? taskData, BuildContext context, TasksController controller,
      {Function()? callBack}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskData != null) {
                  controller.deleteTask(taskData);
                  if (callBack != null) {
                    callBack();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Something went wrong, Please try later',
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Get.back();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
