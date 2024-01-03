import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/database/EntryManager.dart';
import 'package:task_manager_app/database/HumanManager.dart';
import 'package:task_manager_app/database/ProjectManager.dart';
import 'package:task_manager_app/screens/project/AddProjectPage.dart';
import 'package:task_manager_app/screens/project/ViewAllProjectsPage.dart';
import 'package:task_manager_app/screens/account/account_screen.dart';
import 'package:task_manager_app/screens/account/login_screen.dart';
import 'package:task_manager_app/screens/human/AddEmployeePage.dart';
import 'package:task_manager_app/screens/human/EmployeeOverviewPage.dart';
import 'package:task_manager_app/screens/entry/AddEntryPage.dart';
import 'package:task_manager_app/screens/entry/ViewEntryPage.dart';

import 'package:task_manager_app/styles.dart';

class RegisteredContentScreen extends StatelessWidget {
  final ProjectManager projectManager;
  final HumanManager humanManager;
  final EntryManager entryManager;

  const RegisteredContentScreen({
    Key? key,
    required this.projectManager,
    required this.humanManager,
    required this.entryManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Зарегистрированный контент'),
        actions: [
          IconButton(
            onPressed: () {
              if (user == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountScreen(),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.person,
              color: user == null ? Colors.white : Colors.yellow,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: AppStyles.containerDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customButton('Создать новый проект', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddProjectPage(projectManager: projectManager),
                  ),
                );
              }),
              SizedBox(height: 16),
              customButton('Обзор проектов', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewAllProjectsPage(
                        projectManager: projectManager,
                        humanManager: humanManager,
                        entryManager: entryManager),
                  ),
                );
              }),
              SizedBox(height: 16),
              customButton('Добавить сотрудника', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddEmployeePage(humanManager: humanManager),
                  ),
                );
              }),
              SizedBox(height: 16),
              customButton('Обзор сотрудников', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeOverviewPage(
                        humanManager: humanManager,
                        projectManager: projectManager,
                        entryManager: entryManager),
                  ),
                );
              }),
              SizedBox(height: 16),
              customButton('Добавить новую запись', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEntryPage(
                      humanManager: humanManager,
                      projectManager: projectManager,
                      entryManager: entryManager,
                    ),
                  ),
                );
              }),
              SizedBox(height: 16),
              customButton('Учет выдачи проектов сотрудникам', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewEntryPage(
                      humanManager: humanManager,
                      projectManager: projectManager,
                      entryManager: entryManager,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox.shrink(),
    );
  }

  Widget customButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 400.0,
      height: 60.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: AppStyles.buttonShape,
          backgroundColor: AppStyles.buttonBackgroundColor,
        ),
        child: Text(text, style: AppStyles.buttonTextStyle),
      ),
    );
  }
}