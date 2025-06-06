import '../pantallas/login.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await authService.value.createAccount(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return; // <-- Verifica antes de usar context
      // Redirige a la pantalla de Login después de registrarse
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on Exception catch (e) {
      setState(() {
        _error = 'Error al registrar: ${e.toString()}';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                validator:
                    (value) =>
                        value != null && value.contains('@')
                            ? null
                            : 'Correo inválido',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator:
                    (value) =>
                        value != null && value.length >= 6
                            ? null
                            : 'Mínimo 10 caracteres',
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _loading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              _register();
                            }
                          },
                  child:
                      _loading
                          ? const CircularProgressIndicator()
                          : const Text('Registrarse'),
                ),
              ),
              TextButton(
                onPressed:
                    _loading
                        ? null
                        : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
