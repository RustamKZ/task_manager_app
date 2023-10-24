class Task
{
  String taskName;
  String description;
  bool isCompleted;
  DateTime deadline;
  int priority;

  Task({
    required this.taskName,
    required this.description,
    required this.isCompleted,
    required this.deadline,
    required this.priority,
  });
}