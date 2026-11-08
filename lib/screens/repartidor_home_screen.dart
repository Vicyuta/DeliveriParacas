import 'registrar_compra_screen.dart';
import 'package:flutter/material.dart';

class RepartidorHomeScreen extends StatefulWidget {
  const RepartidorHomeScreen({super.key});

  @override
  State<RepartidorHomeScreen> createState() => _RepartidorHomeScreenState();
}

class _RepartidorHomeScreenState extends State<RepartidorHomeScreen> {
  bool _isActivo = false;

  // SOLUCIÓN: Quitamos los símbolos < > para que Dart no se confunda. 
  // Ahora deduce automáticamente que es una lista de datos.
  final _pedidosSimulados = [
    {
      'id': '1',
      'tipo': 'Compras',
      'descripcion': '1/4 de pollo de chifa Yemheng y una inka cola',
      'entrega': 'Plaza de Paracas',
      'distancia': '1.2 km'
    },
    {
      'id': '2',
      'tipo': 'Envío',
      'descripcion': 'Llaves del departamento',
      'origen': 'El Chaco',
      'entrega': 'Hotel San Agustín',
      'distancia': '3.5 km'
    },
  ];

  void _toggleActivo(bool valor) {
    setState(() {
      _isActivo = valor;
    });
    // --- ENCHUFE PARA TU AMIGO ---
    // Aquí debe actualizar el estado de este repartidor en Supabase a "Activo" o "Inactivo".
  }

  void _aceptarPedido(String idPedido) {
  // --- ENCHUFE PARA TU AMIGO ---
  // Aquí actualizará el estado en Supabase a "Aceptado".

  // Navegación hacia la pantalla de registro de compras
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => RegistrarCompraScreen(idPedido: idPedido),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radar de Pedidos'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Row(
            children: [
              Text(
                _isActivo ? 'ACTIVO' : 'INACTIVO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isActivo ? Colors.green : Colors.red,
                ),
              ),
              Switch(
                value: _isActivo,
                activeThumbColor: Colors.green, // SOLUCIÓN a la advertencia azul
                onChanged: _toggleActivo,
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: !_isActivo
          ? const Center(
              child: Text(
                'Conéctate para recibir pedidos',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pedidosSimulados.length,
              itemBuilder: (context, index) {
                final pedido = _pedidosSimulados[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text(
                                pedido['tipo']!,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: pedido['tipo'] == 'Compras' ? Colors.orange : Colors.blue,
                            ),
                            Text(
                              pedido['distancia']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          pedido['descripcion']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        if (pedido.containsKey('origen')) ...[
                          Row(
                            children: [
                              const Icon(Icons.my_location, color: Colors.blue, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text('De: ${pedido['origen']}')),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text('A: ${pedido['entrega']}')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _aceptarPedido(pedido['id']!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Aceptar Pedido', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}