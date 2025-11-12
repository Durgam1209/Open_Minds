import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlertsPage extends StatelessWidget {
  final String userRole; // 'citizen', 'ngo', 'govt'

  const AlertsPage({Key? key, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Firestore collection: 'alerts'
    // Each alert document fields: title, description, timestamp, targetRoles (array of roles)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Alerts'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('alerts')
            .where('targetRoles', arrayContains: userRole) // Alerts meant for this user role
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No alerts at the moment',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final alerts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              final title = alert['title'] ?? 'Alert';
              final description = alert['description'] ?? '';
              final timestamp = alert['timestamp'] != null
                  ? (alert['timestamp'] as Timestamp).toDate()
                  : DateTime.now();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(description),
                  trailing: Text(
                    '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
