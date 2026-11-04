import 'package:flutter/material.dart';
import 'buscando_repartidor_screen.dart'; // Reutilizamos el radar de búsqueda

class EnvioScreen extends StatefulWidget {
  const EnvioScreen({super.key});

  @override
  State<EnvioScreen> createState() => _EnvioScreenState();
}

class _EnvioScreenState extends State<EnvioScreen> {
  final _descripcionController = TextEditingController();
  final _origenController = TextEditingController();
  final _destinoController = TextEditingController();

  void _solicitarRepartidor() {
    if (_descripcionController.text.isEmpty || 
        _origenController.text.isEmpty || 
        _destinoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }
    
    // --- ENCHUFE PARA TU AMIGO ---
    // Aquí él conectará la lógica para subir el pedido de tipo "Envío" a Supabase
    debugPrint("Paquete: ${_descripcionController.text} | De: ${_origenController.text} | A: ${_destinoController.text}");
    
    // Navegación hacia la pantalla de radar que ya creaste antes
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuscandoRepartidorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envío y Entrega'),
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
              '¿Qué vas a enviar?', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                hintText: 'Ej. Unas llaves, documentos, una caja pequeña...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Punto de Recojo (Origen)', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _origenController,
              decoration: InputDecoration(
                hintText: 'Dirección donde está el paquete',
                prefixIcon: const Icon(Icons.my_location, color: Colors.blue),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Punto de Entrega (Destino)', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _destinoController,
              decoration: InputDecoration(
                hintText: 'Dirección a donde debe llegar',
                prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _solicitarRepartidor,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Buscar Repartidor', style: TextStyle(fontSize: 18, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}