import 'package:flutter/material.dart';
import 'compras_screen.dart';
import 'envio_screen.dart';

class ClienteHomeScreen extends StatelessWidget {
  const ClienteHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Qué necesitas hoy?'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOpcionTarjeta(
              context,
              titulo: 'Delivery Compras',
              descripcion: 'Pide productos de tiendas, farmacias o comida.',
              icono: Icons.shopping_bag_outlined,
              color: Colors.orange,
              onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ComprasScreen()),
  );
},
            ),
            const SizedBox(height: 20),
            _buildOpcionTarjeta(
              context,
              titulo: 'Envío y Entrega',
              descripcion: 'Envía paquetes o llaves del punto A al punto B.',
              icono: Icons.local_shipping_outlined,
              color: Colors.blue,
              onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const EnvioScreen()),
  );
},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionTarjeta(
    BuildContext context, {
    required String titulo,
    required String descripcion,
    required IconData icono,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icono, size: 40, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    descripcion,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}