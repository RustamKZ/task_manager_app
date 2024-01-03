// Ваш файл AddProjectPage.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/database/ProjectManager.dart';
import 'package:task_manager_app/models/Project.dart';
import 'package:task_manager_app/styles.dart';

class AddProjectPage extends StatefulWidget {
  final ProjectManager projectManager;

  AddProjectPage({required this.projectManager});

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  Priority? _selectedPriority;
  Status? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить проект'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Название проекта',
                  counterText: '',
                ),
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название проекта';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Описание проекта'),
              ),
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      'Стоимость проекта  (без учета зарплат сотрудникам, в рублях)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите стоимость проекта';
                  }

                  // Добавлено: Проверка, что введенное значение является числом
                  if (int.tryParse(value) == null) {
                    return 'Введите корректное число в поле стоимости проекта';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Продолжительность (в месяцах)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите продолжительность проекта';
                  }

                  // Добавлено: Проверка, что введенное значение является числом
                  if (int.tryParse(value) == null) {
                    return 'Введите корректное число в поле продолжительности проекта';
                  }

                  return null;
                },
              ),
              ListTile(
                title: Text('Приоритетность'),
                subtitle: _selectedPriority == null
                    ? Text('Выбрать приоритетность')
                    : Text(getPriorityString(_selectedPriority!)),
                onTap: () async {
                  Priority? selectedPriority = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Выбрать приоритетность'),
                        content: DropdownButtonFormField(
                          value: _selectedPriority,
                          items: Priority.values.map((Priority priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(getPriorityString(priority)),
                            );
                          }).toList(),
                          onChanged: (Priority? value) {
                            setState(() {
                              _selectedPriority = value;
                              Navigator.of(context).pop(value);
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      );
                    },
                  );
                  if (selectedPriority != null) {
                    setState(() {
                      _selectedPriority = selectedPriority;
                    });
                  }
                },
              ),
              ListTile(
                title: Text('Статус'),
                subtitle: _selectedStatus == null
                    ? Text('Выбрать статус')
                    : Text(getStatusString(_selectedStatus!)),
                onTap: () async {
                  Status? selectedStatus = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Выбрать статус'),
                        content: DropdownButtonFormField(
                          value: _selectedStatus,
                          items: Status.values.map((Status status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(getStatusString(status)),
                            );
                          }).toList(),
                          onChanged: (Status? value) {
                            setState(() {
                              _selectedStatus = value;
                              Navigator.of(context).pop(value);
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      );
                    },
                  );
                  if (selectedStatus != null) {
                    setState(() {
                      _selectedStatus = selectedStatus;
                    });
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Project newProject = Project(
                      id: DateTime.now().toString(),
                      name: _nameController.text,
                      description: _descriptionController.text.isNotEmpty
                          ? _descriptionController.text
                          : null,
                      priority: _selectedPriority,
                      status: _selectedStatus,
                      cost: int.parse(_costController.text),
                      cost_with_humans: int.parse(_costController.text),
                      duration: int.parse(_durationController.text),
                    );
                    widget.projectManager.addProject(newProject);

                    Navigator.pop(context, widget.projectManager.projects);
                  }
                },
                child:
                    Text('Сохранить проект', style: AppStyles.buttonTextStyle),
                style: ElevatedButton.styleFrom(
                  shape: AppStyles.buttonShape,
                  backgroundColor: AppStyles.buttonBackgroundColor,
                ),
              ),
            ],
          ),
        ),
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
}
