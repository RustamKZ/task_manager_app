import 'package:flutter/material.dart';
import 'package:task_manager_app/database/HumanManager.dart';
import 'package:task_manager_app/models/Human.dart';
import 'package:task_manager_app/styles.dart';

class AddEmployeePage extends StatefulWidget {
  final HumanManager humanManager;

  AddEmployeePage({required this.humanManager});

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  Position? _selectedPosition;
  int? _salary; // Добавлено поле "зарплата"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить сотрудника'),
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
                  labelText: 'Имя сотрудника',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя сотрудника';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Должность'),
                subtitle: _selectedPosition == null
                    ? Text('Выбрать должность')
                    : Text(getPositionString(_selectedPosition!)),
                onTap: () async {
                  Position? selectedPosition = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Выбрать должность'),
                        content: DropdownButtonFormField(
                          value: _selectedPosition,
                          items: Position.values.map((Position position) {
                            return DropdownMenuItem(
                              value: position,
                              child: Text(getPositionString(position)),
                            );
                          }).toList(),
                          onChanged: (Position? value) {
                            setState(() {
                              _selectedPosition = value;
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
                  if (selectedPosition != null) {
                    setState(() {
                      _selectedPosition = selectedPosition;
                    });
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Зарплата (руб)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите зарплату';
                  }

                  // Добавлено: Проверка, что введенное значение является числом
                  if (int.tryParse(value) == null) {
                    return 'Введите корректное число в поле зарплаты';
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    // Добавлено: Проверка, что введенное значение является числом
                    _salary = int.tryParse(value);
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Создать нового сотрудника и добавить его в менеджер сотрудников
                    Human newEmployee = Human(
                      id: DateTime.now().toString(),
                      name: _nameController.text,
                      position: _selectedPosition,
                      projects: 0,
                      salary: _salary, // Добавлено поле "зарплата"
                    );
                    widget.humanManager.addHuman(newEmployee);

                    // Вернуть измененный список сотрудников
                    Navigator.pop(context, widget.humanManager.humans);
                  }
                },
                child: Text('Добавить сотрудника',
                    style: AppStyles.buttonTextStyle),
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
