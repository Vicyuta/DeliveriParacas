import 'package:flutter/material.dart';
import 'buscando_repartidor_screen.dart';

class ComprasScreen extends StatefulWidget {
  const ComprasScreen({super.key});

  @override
  State<ComprasScreen> createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
  final _listaController = TextEditingController();
  final _entregaController = TextEditingController();

  void _solicitarRepartidor() {
    if (_listaController.text.isEmpty || _entregaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, detalla tu pedido y el punto de entrega')),
      );
      return;
    }
    
    // --- ENCHUFE PARA TU AMIGO ---
    // Aquí él conectará la lógica para subir el pedido a Supabase
    debugPrint("Pedido: ${_listaController.text} | Entrega: ${_entregaController.text}");
    
    // Navegación hacia la pantalla de radar
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuscandoRepartidorScreen()),
    );
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
                hintText: 'Ej. 1/4 de pollo de la pollería X, paracetamol de la farmacia...',
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
              decoration: InputDecoration(
                hintText: 'Dirección o referencia en Paracas',
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