import 'package:task_manager_app/models/Entry.dart';
import 'package:task_manager_app/models/Human.dart';
import 'package:task_manager_app/models/Project.dart';

class EntryManager {
  List<Entry> entries = [];
  int _nextId = 1;

  int getNextEntryId() {
    return _nextId++;
  }

  void addEntry(Entry entry) {
    entries.add(entry);
  }

  void removeEntry(int entryId) {
    entries.removeWhere((entry) => entry.id == entryId);
  }
  void updateEntriesForProject(Project oldProject, Project newProject) {
  for (Entry entry in entries) {
    if (entry.project.id == oldProject.id) {
      entry.project = newProject;
    }
  }
}
  void updateEntriesForHuman(Human oldHuman, Human newHuman) {
    for (int i = 0; i < entries.length; i++) {
      Entry entry = entries[i];
      if (entry.human.id == oldHuman.id) {
        Entry updatedEntry = Entry(
          id: entry.id,
          project: entry.project,
          human: newHuman,  // Обновленный сотрудник
        );
        entries[i] = updatedEntry;
      }
    }
  }
}
