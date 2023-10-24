import 'package:task_manager_app/models/Task.dart';

class TaskCategory {
  String categoryName;
  List<Task> tasksInCategory;

  TaskCategory({required this.categoryName, List<Task>? tasksInCategory})
      : tasksInCategory = tasksInCategory ?? [];
}
