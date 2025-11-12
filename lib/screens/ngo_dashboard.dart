import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NGODashboardMap extends StatelessWidget {
  // Dummy danger zones
  final List<LatLng> dangerZones = [
    LatLng(12.9716, 77.5946), // Flood Zone
    LatLng(12.2958, 76.6394), // Cyclone Zone
  ];

  // Dummy SOS requests from citizens
  final List<Map<String, dynamic>> sosRequests = [
    {
      'name': 'John Doe',
      'location': LatLng(12.9141, 74.8560),
      'message': 'Need immediate evacuation assistance!',
    },
    {
      'name': 'Jane Smith',
      'location': LatLng(12.9721, 77.5900),
      'message': 'Trapped at home, need food and water.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(12.9716, 77.5946),
        initialZoom: 6.0,
      ),
      children: [
        // Base map tiles
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),

        // Danger zone markers
        MarkerLayer(
          markers: dangerZones
              .map(
                (loc) => Marker(
                  point: loc,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              )
              .toList(),
        ),

        // SOS request markers
        MarkerLayer(
          markers: sosRequests
              .map(
                (sos) => Marker(
                  point: sos['location'] as LatLng,
                  width: 40,
                  height: 40,
                  child: Tooltip(
                    message: "${sos['name']}\n${sos['message']}",
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
