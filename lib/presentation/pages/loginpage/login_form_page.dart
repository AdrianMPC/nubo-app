import 'package:flutter/material.dart';
import 'package:nubo/presentation/views/login/correo_contra_datos_view.dart';

class LoginFormPage extends StatelessWidget {
  static const String name = "login_form_page";
  const LoginFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
