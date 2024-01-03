import 'package:flutter/material.dart';
import 'package:task_manager_app/database/HumanManager.dart';
import 'package:task_manager_app/database/ProjectManager.dart';
import 'package:task_manager_app/database/EntryManager.dart'; // Добавлен импорт
import 'package:task_manager_app/models/Entry.dart';
import 'package:task_manager_app/models/Human.dart';
import 'package:task_manager_app/models/Project.dart';
import 'package:task_manager_app/styles.dart';

class AddEntryPage extends StatefulWidget {
  final HumanManager humanManager;
  final ProjectManager projectManager;
  final EntryManager entryManager; // Добавлено поле

  AddEntryPage(
      {required this.humanManager,
      required this.projectManager,
      required this.entryManager});

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final TextEditingController _nameController = TextEditingController();
  Human? _selectedHuman;
  Project? _selectedProject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить сотрудника к проекту'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<Human>(
              value: _selectedHuman,
              onChanged: (newValue) {
                setState(() {
                  _selectedHuman = newValue;
                });
              },
              items: widget.humanManager.humans.map((human) {
                return DropdownMenuItem<Human>(
                  value: human,
                  child: Text(human.name),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Выберите сотрудника'),
            ),
            DropdownButtonFormField<Project>(
              value: _selectedProject,
              onChanged: (newValue) {
                setState(() {
                  _selectedProject = newValue;
                });
              },
              items: widget.projectManager.projects.map((project) {
                return DropdownMenuItem<Project>(
                  value: project,
                  child: Text(project.name),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Выберите проект'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addEntry(); // Обновлен вызов метода
              },
              child: Text('Добавить сотрудника к проекту',
                  style: AppStyles.buttonTextStyle),
              style: ElevatedButton.styleFrom(
                shape: AppStyles.buttonShape,
                backgroundColor: AppStyles.buttonBackgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addEntry() {
    if (_selectedHuman == null || _selectedProject == null) {
      // Выводите сообщение об ошибке, если данные не выбраны
      return;
    }

    // Проверяем, есть ли сотрудник уже в проекте
    if (_isHumanAlreadyInProject(_selectedHuman!.id, _selectedProject!.id)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Сотрудник "${_selectedHuman!.name}" уже добавлен в проект "${_selectedProject!.name}".'),
      ));
      return;
    }

    // Создаем новую запись и добавляем ее с использованием EntryManager
    widget.entryManager.addEntry(Entry(
      id: widget.entryManager.getNextEntryId(),
      project: _selectedProject!,
      human: _selectedHuman!,
    ));
    // Добавляем сотрудника к проекту
    widget.projectManager
        .addHumanToProject(_selectedProject!.id, _selectedHuman!);
    // Пересчитываем стоимость проекта с учетом новой записи
    widget.projectManager.calculateProjectCost(_selectedProject!.id);

    // Закрываем страницу после добавления
    Navigator.pop(context);
  }

// Метод, который проверяет, есть ли сотрудник уже в проекте
  bool _isHumanAlreadyInProject(String humanId, String projectId) {
    Project project = widget.projectManager.projects
        .firstWhere((project) => project.id == projectId);
    return project.humans != null &&
        project.humans!.any((human) => human.id == humanId);
  }
}
