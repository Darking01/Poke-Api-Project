import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login.dart';
//import '../main.dart';

class AccountOptionsScreen extends StatefulWidget {
  const AccountOptionsScreen({super.key});

  @override
  State<AccountOptionsScreen> createState() => _AccountOptionsScreenState();
}

class _AccountOptionsScreenState extends State<AccountOptionsScreen> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  void sendResetEmail() async {
    try {
      await authService.value.resetPassword(email: emailController.text.trim());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Correo enviado')));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar el correo')),
      );
    }
  }

  void updateUsername() async {
    try {
      await authService.value.updateUsername(
        username: usernameController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nombre actualizado')));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al actualizar')));
    }
  }

  void resetPasswordFromCurrent() async {
    try {
      await authService.value.resetPasswordFromCurrentPassword(
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        email: emailController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Contraseña actualizada')));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar contraseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opciones de Cuenta')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Actualizar nombre de usuario'),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Nuevo nombre'),
          ),
          ElevatedButton(
            onPressed: updateUsername,
            child: const Text('Actualizar'),
          ),

          const Divider(height: 40),

          const Text('Enviar correo de recuperación de contraseña'),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Correo'),
          ),
          ElevatedButton(
            onPressed: sendResetEmail,
            child: const Text('Enviar correo'),
          ),

          const Divider(height: 40),

          const Text('Cambiar contraseña actual'),
          TextField(
            controller: currentPasswordController,
            decoration: const InputDecoration(labelText: 'Contraseña actual'),
            obscureText: true,
          ),
          TextField(
            controller: newPasswordController,
            decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: resetPasswordFromCurrent,
            child: const Text('Cambiar contraseña'),
          ),

          const Divider(height: 40),

          // Botón para cerrar sesión
          ElevatedButton(
            onPressed: () async {
              await authService.value.signOut();
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
