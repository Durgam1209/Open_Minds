import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GovtDashboard extends StatefulWidget {
  const GovtDashboard({super.key});

  @override
  State<GovtDashboard> createState() => _GovtDashboardState();
}

class _GovtDashboardState extends State<GovtDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy alerts for validation
  final List<Map<String, String>> pendingAlerts = [
    {
      'title': 'Flood detected Zone 3',
      'description': 'AI model predicts heavy rainfall.',
      'status': 'Pending'
    },
    {
      'title': 'Cyclone Warning',
      'description': 'Strong winds expected in coastal areas.',
      'status': 'Pending'
    },
  ];

  // Dummy messages to broadcast
  final TextEditingController messageController = TextEditingController();

  // Dummy danger zone coordinates
  final List<LatLng> dangerZones = [
    LatLng(12.9716, 77.5946),
    LatLng(12.2958, 76.6394),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void broadcastMessage() {
    final msg = messageController.text;
    if (msg.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Broadcasted: $msg')),
      );
      messageController.clear();
    }
  }

  void validateAlert(int index) {
    setState(() {
      pendingAlerts[index]['status'] = 'Validated';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alert "${pendingAlerts[index]['title']}" validated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.check_circle), text: 'Validate Alerts'),
            Tab(icon: Icon(Icons.message), text: 'Broadcast'),
            Tab(icon: Icon(Icons.map), text: 'Map'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Validate Alerts Tab
          ListView.builder(
            itemCount: pendingAlerts.length,
            itemBuilder: (context, index) {
              final alert = pendingAlerts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Icon(
                    alert['status'] == 'Validated' ? Icons.check_circle : Icons.warning,
                    color: alert['status'] == 'Validated' ? Colors.green : Colors.red,
                  ),
                  title: Text(alert['title']!),
                  subtitle: Text(alert['description']!),
                  trailing: alert['status'] == 'Pending'
                      ? ElevatedButton(
                          onPressed: () => validateAlert(index),
                          child: const Text('Validate'),
                        )
                      : null,
                ),
              );
            },
          ),

          // Broadcast Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    labelText: 'Enter message to broadcast',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: broadcastMessage,
                  child: const Text('Broadcast'),
                ),
              ],
            ),
          ),

          // Map Tab using flutter_map
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(12.9716, 77.5946),
              initialZoom: 6,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: dangerZones
                    .map((loc) => Marker(
                          point: loc,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
