import 'package:flutter/material.dart';
import 'package:task_manager_app/database/EntryManager.dart';
import 'package:task_manager_app/database/HumanManager.dart';
import 'package:task_manager_app/database/ProjectManager.dart';
import 'package:task_manager_app/models/Entry.dart';
import 'package:task_manager_app/models/Human.dart';
import 'package:task_manager_app/models/Project.dart';

class ViewEntryPage extends StatefulWidget {
  final HumanManager humanManager;
  final ProjectManager projectManager;
  final EntryManager entryManager;

  ViewEntryPage({
    required this.humanManager,
    required this.projectManager,
    required this.entryManager,
  });
  @override
  _ViewEntryPageState createState() => _ViewEntryPageState();
}

class _ViewEntryPageState extends State<ViewEntryPage> {
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

  void _removeEntry(int id) {
    setState(() {
      Entry removedEntry = widget.entryManager.entries.firstWhere(
        (entry) => entry.id == id,
      );

      if (removedEntry.id != -1) {
        Human removedHuman = removedEntry.human;
        Project removedProject = removedEntry.project;

        // Удаляем человека из проекта
        int projectIndex = widget.projectManager.projects
            .indexWhere((project) => project.id == removedProject.id);
        if (projectIndex != -1) {
          widget.projectManager.projects[projectIndex].humans
              ?.removeWhere((h) => h.id == removedHuman.id);
          widget.projectManager.calculateProjectCost(removedProject.id);
        }

        // Удаляем запись из менеджера записей
        widget.entryManager.removeEntry(id);

        // После удаления записи, вызываем перерасчет стоимости проекта
        // для каждого проекта в списке.
        widget.projectManager.projects.forEach((project) {
          widget.projectManager.calculateProjectCost(project.id);
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Запись удалена'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Просмотр записей'),
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
                  child: Text('№', style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        Text('Название проекта', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Продолжительность проекта',
                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Имя сотрудника', textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Должность', textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
              ],
            ),
          ),

          // Строки с записями
          ...widget.entryManager.entries.map((entry) {
            return Dismissible(
              key: Key(entry.id.toString()),
              onDismissed: (direction) {
                _removeEntry(entry.id);
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
                  // Handle entry tap if needed
                  // For example, you can edit the entry
                  // selectedEntry = entry;
                  // _editEntry(context);
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
                        child: Text(entry.id.toString(),style:
                                TextStyle(color: Colors.white, fontSize: 18.0)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(entry.project.name,
                              textAlign: TextAlign.center,style:
                                TextStyle(color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('${entry.project.duration} мес',
                              textAlign: TextAlign.center,style:
                                TextStyle(color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(entry.human.name,
                              textAlign: TextAlign.center,style:
                                TextStyle(color: Colors.white, fontSize: 18.0)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              getPositionString(
                                  entry.human.position ?? Position.developer),
                              textAlign: TextAlign.center,style:
                                TextStyle(color: Colors.white, fontSize: 18.0)),
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
}
