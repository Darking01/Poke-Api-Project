import '../services/auth_service.dart';
//import 'package:flutter/src/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'inicio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  void login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await authService.value.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return; // Verifica antes de usar context
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Inicio()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Error al iniciar sesión';
      });
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  void goToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void showResetPasswordDialog() {
    final resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Recuperar contraseña'),
            content: TextField(
              controller: resetEmailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await authService.value.resetPassword(
                      email: resetEmailController.text.trim(),
                    );
                    if (!mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Correo de recuperación enviado'),
                      ),
                    );
                  } catch (_) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al enviar el correo'),
                      ),
                    );
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: login,
                  child: const Text('Ingresar'),
                ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: goToRegister,
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
            TextButton(
              onPressed: showResetPasswordDialog,
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ],
        ),
      ),
    );
  }
}
