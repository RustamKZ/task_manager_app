import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/database/EntryManager.dart';
import 'package:task_manager_app/database/HumanManager.dart';
import 'package:task_manager_app/database/ProjectManager.dart';
import 'package:task_manager_app/models/Human.dart';
import 'package:task_manager_app/models/Project.dart';

class EmployeeOverviewPage extends StatefulWidget {
  final HumanManager humanManager;
  final ProjectManager projectManager;
  final EntryManager entryManager;

  EmployeeOverviewPage(
      {required this.humanManager,
      required this.projectManager,
      required this.entryManager});

  @override
  _EmployeeOverviewPageState createState() => _EmployeeOverviewPageState();
}

class _EmployeeOverviewPageState extends State<EmployeeOverviewPage> {
  Human? selectedHuman;

  void _removeHuman(String id) {
    setState(() {
      widget.humanManager.removeHuman(id, widget.projectManager.projects);

      // После удаления человека, вызовите перерасчет стоимости проекта
      // для каждого проекта в списке.
      widget.projectManager.projects.forEach((project) {
        widget.projectManager.calculateProjectCost(project.id);
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Сотрудник удален'),
    ));
  }

  String getProjectsString(String humanId, List<Project> projects) {
    List<String> projectNames = [];

    projects.forEach((project) {
      if (project.humans != null &&
          project.humans!.any((human) => human.id == humanId)) {
        projectNames.add(project.name);
      }
    });

    return projectNames.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Обзор сотрудников'),
        ),
      ),
      body: ListView(
        children: [
          // Отступ сверху
          SizedBox(height: 16),
          // Первая строка с заголовками
          Container(
            color: Color.fromRGBO(0, 34, 107, 0.89),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('№',
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Фамилия Имя Отчество',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Должность',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                // Новый столбец
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Проекты',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                // Новый столбец
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Зарплата',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
              ],
            ),
          ),
          // Строки с сотрудниками
          ...widget.humanManager.humans.map((human) {
            Color cellColor;
            switch (human.position) {
              case Position.projectManager:
                cellColor = Colors.green;
                break;
              case Position.developer:
                cellColor = Color.fromARGB(255, 255, 146, 3);
                break;
              case Position.designer:
                cellColor = Colors.red;
                break;
              case Position.tester:
                cellColor = Colors.blue;
                break;
              case Position.marketer:
                cellColor = Colors.purple;
                break;
              default:
                cellColor = Colors.white;
            }

            return Dismissible(
              key: Key(human.id),
              confirmDismiss: (direction) async {
                if (hasProjects(human.id)) {
                  // Предупреждение, что сотрудник связан с проектами
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Нельзя удалить сотрудника "${human.name}", так как он связан с проектами.'),
                  ));
                  return false; // Возвращаем false, чтобы отменить удаление
                } else {
                  // Удаление сотрудника, так как у него нет проектов
                  _removeHuman(human.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Сотрудник "${human.name}" удален'),
                  ));
                  return true; // Возвращаем true, чтобы подтвердить удаление
                }
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: InkWell(
                onTap: () async {
                  selectedHuman = human;
                  _editHuman(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  color: Color.fromARGB(255, 95, 114, 223),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            (widget.humanManager.humans.indexOf(human) + 1)
                                .toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(human.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: cellColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                                getPositionString(
                                    human.position ?? Position.developer),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                          ),
                        ),
                      ),
                      // Новый столбец
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              getProjectsString(
                                  human.id, widget.projectManager.projects),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      // Новый столбец
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('${human.salary} руб',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  bool hasProjects(String humanId) {
    return widget.projectManager.projects.any((project) =>
        project.humans != null &&
        project.humans!.any((human) => human.id == humanId));
  }

  Future<void> _editHuman(BuildContext context) async {
    if (selectedHuman == null) return;

    TextEditingController nameController =
        TextEditingController(text: selectedHuman!.name);
    Position? position = selectedHuman!.position;
    int? salary = selectedHuman!.salary;

    Human? updatedHuman = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Редактирование сотрудника'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ФИО сотрудника'),
                ),
                DropdownButtonFormField<Position>(
                  decoration: InputDecoration(labelText: 'Должность'),
                  value: position,
                  items: Position.values.map((Position position) {
                    return DropdownMenuItem<Position>(
                      value: position,
                      child: Text(getPositionString(position)),
                    );
                  }).toList(),
                  onChanged: (Position? value) {
                    setState(() {
                      position = value;
                    });
                  },
                ),
                // Новое поле для редактирования зарплаты
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: salary?.toString(),
                  decoration: InputDecoration(labelText: 'Зарплата (руб)'),
                  onChanged: (value) {
                    salary = int.tryParse(value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                  Human(
                    id: selectedHuman!.id,
                    name: nameController.text,
                    position: position,
                    salary: salary,
                  ),
                );
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );

    if (updatedHuman != null) {
      _updateHuman(updatedHuman);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Сотрудник "${updatedHuman.name}" обновлен'),
      ));
    }
  }

  void _updateHuman(Human updatedHuman) {
    setState(() {
      widget.humanManager.editHuman(selectedHuman!.id, updatedHuman);

      // Обновление информации о сотруднике в каждом проекте
      widget.projectManager.projects.forEach((project) {
        int index = project.humans
                ?.indexWhere((human) => human.id == selectedHuman!.id) ??
            -1;
        if (index != -1) {
          setState(() {
            project.humans![index] = updatedHuman;
          });
          widget.projectManager.calculateProjectCost(project.id);
        }
      });
      _notifyEntriesAboutHumanUpdate(updatedHuman);
    });
  }

  void _notifyEntriesAboutHumanUpdate(Human updatedHuman) {
    widget.entryManager.updateEntriesForHuman(selectedHuman!, updatedHuman);
  }

  String getPositionString(Position position) {
    switch (position) {
      case Position.projectManager:
        return 'Менеджер проекта';
      case Position.developer:
        return 'Разработчик';
      case Position.designer:
        return 'Дизайнер';
      case Position.tester:
        return 'Тестировщик';
      case Position.marketer:
        return 'Маркетолог';
      default:
        return '';
    }
  }
}
