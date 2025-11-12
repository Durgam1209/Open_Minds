import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:disaster_management_app/screens/role_selection.dart';
import 'package:disaster_management_app/screens/login.dart';
import 'package:disaster_management_app/screens/alert_details.dart'; // import AlertsPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // use super.key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQLink',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleSelectionScreen(),
        '/login': (context) => const LoginScreen(role: ''),
      },
      onGenerateRoute: (settings) {
        // Handle routes that need arguments
        if (settings.name == '/home') {
          final role = settings.arguments as String? ?? 'citizen';
          return MaterialPageRoute(
            builder: (context) => AlertsPage(userRole: role), // pass role
            settings: RouteSettings(arguments: role),
          );
        }
        return null;
      },
    );
  }
}
