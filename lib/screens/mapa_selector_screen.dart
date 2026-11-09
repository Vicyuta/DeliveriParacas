import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaSelectorScreen extends StatefulWidget {
  const MapaSelectorScreen({super.key});

  @override
  State<MapaSelectorScreen> createState() => _MapaSelectorScreenState();
}

class _MapaSelectorScreenState extends State<MapaSelectorScreen> {
  final MapController _mapController = MapController();
  // Coordenadas centrales de Paracas, Ica
  LatLng _centroActual = const LatLng(-13.834, -76.250);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fija tu ubicación'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centroActual,
              initialZoom: 15.0,
              onPositionChanged: (position, hasGesture) {
                // Se corrigió la advertencia amarilla aquí
                setState(() {
                  _centroActual = position.center;
                });
              },
            ),
            children: [
              TileLayer(
                // Servidor de mapas 100% gratuito de OpenStreetMap
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.deliveri_paracas',
              ),
            ],
          ),
          // PIN estático en el centro exacto de la pantalla
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Icon(Icons.location_on, size: 50, color: Colors.red),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Devolvemos la latitud y longitud exactas a la pantalla anterior
          Navigator.pop(context, _centroActual);
        },
        label: const Text('Confirmar Ubicación', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.check, color: Colors.white),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}