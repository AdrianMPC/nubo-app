import 'package:flutter/material.dart';
import 'package:nubo/presentation/views/home/headerwidget.dart';

class HomePage extends StatelessWidget {
  static const String name = 'home_page';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // --- Header de saludo ---
            const HomeGreetingHeader(
            // TODO: Cambiar por whatever nos da el backend
              name: 'Armando', 
              streak: 10,
            ),
            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}
