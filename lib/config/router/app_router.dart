import 'package:go_router/go_router.dart';
import 'package:nubo/presentation/pages/pages.dart';
import 'package:nubo/presentation/screens/recuperar_contrasena_page.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: LoginPage.name,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/login-form',
      name: LoginFormPage.name,
      builder: (context, state) => const LoginFormPage(),
    ),
    GoRoute(
      path: '/recuperar-contrasena',
      builder: (context, state) => const RecuperarContrasenaPage(),
    )
  ],
);
