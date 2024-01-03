import 'package:task_manager_app/models/Human.dart';
import 'package:task_manager_app/models/Project.dart';

class Entry {
  final int id;
  Project project;
  Human human;

  Entry({required this.id, required this.project, required this.human});
}
