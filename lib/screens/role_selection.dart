// lib/screens/role_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:disaster_management_app/screens/login.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _navigateToLogin(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(title: const Text('Smart Disaster Alert System')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login as:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Citizen / User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _navigateToLogin(context, 'user'),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.volunteer_activism),
              label: const Text('NGO Volunteer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _navigateToLogin(context, 'ngo'),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.account_balance),
              label: const Text('Government / Authority'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _navigateToLogin(context, 'govt'),
            ),
          ],
        ),
      ),
    );
  }
}
