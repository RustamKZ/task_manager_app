import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/database/EntryManager.dart';
import 'package:task_manager_app/database/HumanManager.dart';
import 'package:task_manager_app/database/ProjectManager.dart';
import 'package:task_manager_app/models/Human.dart';
import 'package:task_manager_app/models/Project.dart';

class ViewAllProjectsPage extends StatefulWidget {
  final ProjectManager projectManager;
  final HumanManager humanManager;
  final EntryManager entryManager;

  ViewAllProjectsPage(
      {required this.projectManager,
      required this.humanManager,
      required this.entryManager});

  @override
  _ViewAllProjectsPageState createState() => _ViewAllProjectsPageState();
}

class _ViewAllProjectsPageState extends State<ViewAllProjectsPage> {
  Project? selectedProject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Все проекты'),
        ),
      ),
      body: ListView(
        children: [
          // Отступ сверху
          SizedBox(height: 16),
          // Первая строка с заголовками
          Container(
            color: Color.fromRGBO(0, 34, 107, 0.89),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('№',
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Название',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Изначальная стоимость',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Стоимость с учетом зарплаты',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text('Продолжительность',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Приоритет',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Статус',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Кол-во сотрудников',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
              ],
            ),
          ),
          // Строки с проектами
          ...widget.projectManager.projects.map((project) {
            Color cellColor;
            switch (project.status) {
              case Status.done:
                cellColor = Colors.green;
                break;
              case Status.inProgress:
                cellColor = Color.fromARGB(255, 247, 143, 45);
                break;
              case Status.notDone:
                cellColor = Colors.red;
                break;
              default:
                cellColor = Color.fromARGB(255, 68, 55, 55);
            }

            return Dismissible(
              key: Key(project.id),
              confirmDismiss: (direction) async {
                if (project.humans != null && project.humans!.isNotEmpty) {
                  // Предупреждение, что проект связан с сотрудниками
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Нельзя удалить проект "${project.name}", так как он связан с сотрудниками.'),
                  ));
                  return false; // Возвращаем false, чтобы отменить удаление
                } else {
                  // Удаление проекта, так как он не связан с сотрудниками
                  widget.projectManager.removeProject(project.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Проект "${project.name}" удален'),
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
                  selectedProject = project;
                  _editProject(context);
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  color: Color.fromARGB(255, 95, 114, 223),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            (widget.projectManager.projects.indexOf(project) +
                                    1)
                                .toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(project.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('${project.cost} руб',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('${project.cost_with_humans} руб',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('${project.duration} мес',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              getPriorityString(
                                  project.priority ?? Priority.low),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: 50, // Задайте фиксированную ширину
                            height: 100, // Задайте фиксированную высоту
                            decoration: BoxDecoration(
                              color: cellColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      getStatusString(project.status ??
                                          Status.defaultstatus),
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          List<Human>? projectHumans = widget.projectManager
                              .getProjectHumans(project.id);
                          _showProjectHumansDialog(projectHumans);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text((project.humansValue ?? 0).toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                          ),
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

  String getPriorityString(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'Высокий';
      case Priority.medium:
        return 'Средний';
      case Priority.low:
        return 'Низкий';
      default:
        return '';
    }
  }

  String getStatusString(Status status) {
    switch (status) {
      case Status.done:
        return 'Выполнено';
      case Status.inProgress:
        return 'В процессе';
      case Status.notDone:
        return 'Не выполнено';
      case Status.defaultstatus:
        return 'Отсутствует';
      default:
        return '';
    }
  }

  Future<void> _editProject(BuildContext context) async {
    if (selectedProject == null) return;

    TextEditingController nameController =
        TextEditingController(text: selectedProject!.name);
    TextEditingController descriptionController =
        TextEditingController(text: selectedProject!.description);
    Priority? priority = selectedProject!.priority;
    Status? status = selectedProject!.status;
    int? cost = selectedProject!.cost;
    int? duration = selectedProject!.duration;

    Project? updatedProject = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Редактирование проекта'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Название проекта'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Описание проекта'),
                ),
                DropdownButtonFormField<Priority>(
                  decoration: InputDecoration(labelText: 'Приоритет'),
                  value: priority,
                  items: Priority.values.map((Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(getPriorityString(priority)),
                    );
                  }).toList(),
                  onChanged: (Priority? value) {
                    setState(() {
                      priority = value;
                    });
                  },
                ),
                DropdownButtonFormField<Status>(
                  decoration: InputDecoration(labelText: 'Статус'),
                  value: status,
                  items: Status.values.map((Status status) {
                    return DropdownMenuItem<Status>(
                      value: status,
                      child: Text(getStatusString(status)),
                    );
                  }).toList(),
                  onChanged: (Status? value) {
                    setState(() {
                      status = value;
                    });
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Стоимость (руб)'),
                  initialValue: cost?.toString(),
                  onChanged: (value) {
                    cost = int.tryParse(value);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Продолжительность (мес)'),
                  initialValue: duration?.toString(),
                  onChanged: (value) {
                    duration = int.tryParse(value);
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
                  Project(
                    id: selectedProject!.id,
                    name: nameController.text,
                    description: descriptionController.text,
                    priority: priority,
                    status: status,
                    cost: cost,
                    duration: duration,
                  ),
                );
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );

    if (updatedProject != null) {
      _updateProject(updatedProject);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Проект "${updatedProject.name}" обновлен'),
      ));
    }
  }

  void _updateProject(Project updatedProject) {
    setState(() {
      // Копируем список проектов
      List<Project> updatedProjects = List.from(widget.projectManager.projects);

      // Находим индекс старого проекта
      int index = updatedProjects
          .indexWhere((project) => project.id == selectedProject!.id);

      if (index != -1) {
        // Создаем новый объект проекта с обновленными данными
        Project newProject = Project(
          id: selectedProject!.id,
          name: updatedProject.name,
          description: updatedProject.description,
          priority: updatedProject.priority,
          status: updatedProject.status,
          cost: updatedProject.cost,
          cost_with_humans: updatedProject.cost,
          duration: updatedProject.duration,
          humans: widget.projectManager.getProjectHumans(selectedProject!.id),
        );

        // Заменяем старый проект на новый в списке проектов
        updatedProjects[index] = newProject;

        // Обновляем состояние
        widget.projectManager.setProjects(updatedProjects);
        // Пересчитываем стоимость проекта с учетом зарплаты сотрудников
        widget.projectManager.calculateProjectCost(selectedProject!.id);
        // Оповестить EntryManager об изменении данных проекта
        widget.entryManager
            .updateEntriesForProject(selectedProject!, newProject);
      }
    });
  }

  void _showProjectHumansDialog(List<Human>? projectHumans) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Сотрудники в проекте'),
          content: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(label: Text('Имя')),
                DataColumn(label: Text('Должность')),
              ],
              rows: projectHumans?.map<DataRow>((human) {
                    return DataRow(cells: [
                      DataCell(Text(human.name)),
                      DataCell(Text(getPositionString(
                          human.position ?? Position.projectManager))),
                    ]);
                  }).toList() ??
                  [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  void updateSelectedProject(Project updatedProject) {
    setState(() {
      selectedProject = updatedProject;
      widget.projectManager
          .updateProject(updatedProject); // Обновите проект в ProjectManager
      widget.entryManager
          .updateEntriesForProject(selectedProject!, updatedProject);
    });
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
