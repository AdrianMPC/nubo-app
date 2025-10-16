import 'package:flutter/material.dart';
import 'package:nubo/presentation/views/login/login_view.dart';

class LoginPage extends StatelessWidget {
  static const String name = "login_page";
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: LoginButtons(),
          ),
        ),
      ),
    );
  }
}