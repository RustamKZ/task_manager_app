import 'package:task_manager_app/models/Entry.dart';
import 'package:task_manager_app/models/Human.dart';

enum Priority { high, medium, low }

enum Status { done, inProgress, notDone, defaultstatus }

class Project {
  String id;
  String name;
  String? description;
  Priority? priority;
  Status? status;
  List<Human>? humans;
  int? humansValue;
  int? cost;
  int? cost_with_humans;
  int? duration;

  Project({
    required this.id,
    required this.name,
    this.description,
    this.priority,
    this.status,
    this.humans,
    this.cost,
    this.cost_with_humans,
    this.duration,
  }): humansValue = humans?.length;

  // Метод для обновления списка humans и humansValue
  void updateHumans(List<Human>? newHumans) {
    humans = newHumans;
    humansValue = newHumans?.length;
     print('Updated humansValue: $humansValue');
  }
  
}
