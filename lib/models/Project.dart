import 'package:task_manager_app/models/Task.dart';

class Project {
  String projectName;
  String description;
  DateTime? deadline;
  List<Task> tasks;

  Project({
    required this.projectName,
    this.description = "",
    this.deadline,
    List<Task>? tasks,
  }) : tasks = tasks ?? [];
}
