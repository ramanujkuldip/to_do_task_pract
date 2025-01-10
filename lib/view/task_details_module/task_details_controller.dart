
import 'package:get/get.dart';

import '../../model/task_model.dart';
import '../tasks_list_module/tasks_controller.dart';

class TaskDetailsController extends GetxController {
  TaskModel taskModel;
  TasksController tasksController = Get.find<TasksController>();
  TaskDetailsController({required this.taskModel});
}