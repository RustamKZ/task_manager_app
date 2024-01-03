import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/screens/account_screen.dart';
import 'package:task_manager_app/screens/login_screen.dart';

class RegisteredContentScreen extends StatelessWidget {
  const RegisteredContentScreen({Key? key}) : super(key: key);
  
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
      body: const Center(
        child: Text('Это контент для зарегистрированных пользователей'),
      ),
    );
  }
}
