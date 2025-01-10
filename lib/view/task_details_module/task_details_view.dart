import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/enums.dart';
import '../../constants/utils.dart';
import '../../model/task_model.dart';
import '../../widgets/base_button.dart';
import '../tasks_list_module/tasks_view.dart';
import 'task_details_controller.dart';

class TaskDetailsView extends StatelessWidget {
  final TaskModel taskModel;

  const TaskDetailsView({required this.taskModel, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TaskDetailsController(taskModel: taskModel),
      dispose: (state) => Get.delete<TaskDetailsController>(),
      builder: (controller) {
        return Scaffold(
          appBar: getAppBar(controller),
          body: mainBody(controller.taskModel),
          bottomNavigationBar: bottomNavBarView(context, controller),
        );
      },
    );
  }

  SafeArea mainBody(TaskModel taskModel) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: const Text(
                    "Task Name:",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (taskModel.priority != null &&
                        taskModel.priority!.isNotEmpty)
                      getPriorityCard(
                        taskModel.priority ?? "",
                      ),
                    if (taskModel.priority != null &&
                        taskModel.priority!.isNotEmpty)
                      const SizedBox(width: 5),
                    if (taskModel.priority != null &&
                        taskModel.priority!.isNotEmpty)
                      getChipCard(
                        taskModel.isCompleted == 0
                            ? TaskStatus.pending.name
                            : TaskStatus.completed.name,
                        taskModel.isCompleted == 1,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              taskModel.taskName ?? " ",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              "Due Date:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Utils.convertTimeStampToDateTime(taskModel.dueDate ?? 0),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Description:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              taskModel.description ?? " - ",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
      ),
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
          fontSize: 12,
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

  AppBar getAppBar(TaskDetailsController controller) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Task Details",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            TasksListView.showDeleteDialog(
              controller.taskModel,
              Get.context!,
              controller.tasksController,
              callBack: () {
                Get.back();
              },
            );
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  SafeArea bottomNavBarView(
    BuildContext context,
    TaskDetailsController controller,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: BaseButton(
          onTap:() async {
            TasksListView.showForm(
              context: context,
              controller: controller.tasksController,
              taskData: controller.taskModel,
              thenCallBack: (val) {
                if (val != null) {
                  print(val.isCompleted);
                  controller.taskModel = val;
                  controller.update();
                }
              },
            );
          },
          buttonText:"Update",
        ),
      ),
    );
  }
}
