import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserDashboard extends StatefulWidget {
  final String userRole; // 'citizen' or 'ngo'
  const UserDashboard({super.key, required this.userRole});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy alert data
  final List<Map<String, String>> alerts = [
    {
      'title': 'Flood Warning in Zone 3',
      'description': 'Heavy rainfall expected. Move to safe shelter immediately.'
    },
    {
      'title': 'Cyclone Alert',
      'description': 'Cyclone expected in coastal areas. Stay indoors.'
    },
  ];

  // Dummy map markers using latlong2
  final List<LatLng> dangerZones = [
    LatLng(12.9716, 77.5946),
    LatLng(12.2958, 76.6394),
  ];

  // Dummy F1-style chart data
  final List<BarChartGroupData> barData = [
    BarChartGroupData(
      x: 0,
      barRods: [BarChartRodData(toY: 5, color: Colors.red, width: 25)],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [BarChartRodData(toY: 2, color: Colors.orange, width: 25)],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [BarChartRodData(toY: 1, color: Colors.blue, width: 25)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.notifications), text: 'Alerts'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Graphs'),
            Tab(icon: Icon(Icons.map), text: 'Map'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Alerts Tab
          ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(alert['title']!),
                  subtitle: Text(alert['description']!),
                ),
              );
            },
          ),

          // Graph Tab
          Padding(
            padding: const EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                barGroups: barData,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['Flood', 'Cyclone', 'Earthquake'];
                        if (value.toInt() < labels.length) {
                          return Text(labels[value.toInt()]);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
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
                    .map(
                      (loc) => Marker(
                        point: loc,
                        width: 40,
                        height: 40,
                        child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
