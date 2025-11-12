// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'user_dashboard.dart';
import 'ngo_dashboard.dart';
import 'ndrf_dashboard.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // TODO: Replace with backend auth later
    Widget nextScreen;
    if (widget.role == 'user') {
      nextScreen = const UserDashboard(userRole: 'citizen',);
    } else if (widget.role == 'ngo') {
      nextScreen = NGODashboardMap();
    } else {
      nextScreen = const GovtDashboard();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.role.toUpperCase()} Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 145, 169, 210),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
