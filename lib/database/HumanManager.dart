import 'package:flutter/foundation.dart';
import 'package:task_manager_app/models/Human.dart';
import 'package:task_manager_app/models/Project.dart';

class HumanManager {
  List<Human> _humans = [];

  List<Human> get humans => _humans;

  void addHuman(Human human) {
    _humans.add(human);
  }

 void removeHuman(String id, List<Project> projects) {
    _humans.removeWhere((human) => human.id == id);
    
    for (Project project in projects) {
      project.humans?.removeWhere((human) {
        if (human.id == id) {
          project.humansValue = (project.humansValue ?? 0) - 1;

          // Уменьшение количества проектов у человека
          human.projects = (human.projects ?? 0) - 1;

          return true;
        }
        return false;
      });
    }
  }


  void editHuman(String id, Human editedHuman) { // Изменение типа параметра на String
    int index = _humans.indexWhere((human) => human.id == id);
    if (index != -1) {
      _humans[index] = editedHuman;
    }
  }
  
  void updateHuman(Human updatedHuman) {
    int index = _humans.indexWhere((human) => human.id == updatedHuman.id);
    if (index != -1) {
      _humans[index] = updatedHuman;
    }
  }
}
