import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/database/EntryManager.dart';
import 'package:task_manager_app/database/HumanManager.dart';
import 'package:task_manager_app/database/ProjectManager.dart';
import 'package:task_manager_app/main.dart';
import 'package:task_manager_app/screens/RegisteredContentScreen.dart';
import 'package:task_manager_app/screens/account/account_screen.dart';
import 'package:task_manager_app/screens/account/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final ProjectManager projectManager = ProjectManager();
  final HumanManager humanManager = HumanManager();
  final EntryManager entryManager = EntryManager(); // Добавлено поле

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Главная страница'),
        actions: [
          IconButton(
            onPressed: () {
              if ((user == null)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
              }
            },
            icon: Icon(
              Icons.person,
              color: (user == null) ? Colors.white : Colors.yellow,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: (user == null)
              ? const Text("Контент для НЕ зарегистрированных в системе")
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(
                           builder: (context) => RegisteredContentScreen(projectManager: projectManager, humanManager: humanManager, entryManager: entryManager,),
              ),
            );
          },
          child: const Text('Начать работу!'),
          ),
        ),
      ),
    );
  }
}