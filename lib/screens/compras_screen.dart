import 'package:flutter/material.dart';
import 'package:latlong2/latlong2.dart'; 
import 'buscando_repartidor_screen.dart';
import '../supabase_service.dart';
import 'mapa_selector_screen.dart'; 

class ComprasScreen extends StatefulWidget {
  const ComprasScreen({super.key});

  @override
  State<ComprasScreen> createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
  final _listaController = TextEditingController();
  final _entregaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _abrirMapa() async {
    final LatLng? ubicacion = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapaSelectorScreen()),
    );

    if (ubicacion != null) {
      setState(() {
        final lat = ubicacion.latitude.toStringAsFixed(5);
        final lng = ubicacion.longitude.toStringAsFixed(5);
        _entregaController.text = "GPS: $lat, $lng";
      });
    }
  }

  Future<void> _solicitarRepartidor() async {
    if (_listaController.text.isEmpty || _entregaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Detalla el pedido y selecciona en el mapa')),
      );
      return;
    }
    
    setState(() => _isLoading = true);

    try {
      final servicio = SupabaseService();
      await servicio.crearPedidoCompras(
        _listaController.text, 
        _entregaController.text
      );

      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BuscandoRepartidorScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar el pedido: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery de Compras'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Qué necesitas que compremos?', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _listaController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Ej. 1/4 de pollo de la pollería X, paracetamol...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Punto de Entrega (Obligatorio)', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 10),
            
            TextField(
              controller: _entregaController,
              readOnly: true, 
              onTap: _abrirMapa, 
              decoration: InputDecoration(
                hintText: 'Toca aquí para abrir el mapa...',
                prefixIcon: const Icon(Icons.map, color: Colors.red),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _solicitarRepartidor,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Buscar Repartidor', style: TextStyle(fontSize: 18, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}