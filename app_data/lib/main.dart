import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pantallas/login.dart';
import 'pantallas/inicio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'package:provider/provider.dart';
import 'Models/inicio_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => InicioController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthService>(
      valueListenable: authService,
      builder: (context, service, _) {
        return StreamBuilder<User?>(
          stream: service.authStateChanges,
          builder: (context, snapshot) {
            // Si el usuario está autenticado, va a Inicio, si no, va a LoginScreen
            if (snapshot.connectionState == ConnectionState.active) {
              final user = snapshot.data;
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Pokémon App',
                theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
                home: user != null ? const Inicio() : const LoginScreen(),
              );
            }
            // Mientras se conecta, muestra un loader
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          },
        );
      },
    );
  }
}
