import 'package:flutter/material.dart';

class RegistrarCompraScreen extends StatefulWidget {
  final String idPedido;
  
  const RegistrarCompraScreen({super.key, required this.idPedido});

  @override
  State<RegistrarCompraScreen> createState() => _RegistrarCompraScreenState();
}

class _RegistrarCompraScreenState extends State<RegistrarCompraScreen> {
  final _montoController = TextEditingController();
  
  // Lista temporal para el diseño. Tu amigo la reemplazará enviando 
  // los datos directamente a Supabase para que el cliente los vea en tiempo real (RF-06).
  final _comprasRegistradas = [];

  void _adjuntarFoto() {
    // --- ENCHUFE PARA TU AMIGO ---
    // Aquí implementarán el paquete 'image_picker' para abrir la cámara,
    // y luego subirán la foto comprimida (RNF-01) a los buckets de Supabase.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulando abrir cámara para el voucher...')),
    );
  }

  void _agregarGasto() {
    if (_montoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el monto de la compra')),
      );
      return;
    }

    // Simulamos agregar el gasto localmente
    setState(() {
      _comprasRegistradas.add({
        'monto': _montoController.text,
        'foto': 'voucher_temp.jpg' // Simulación
      });
      _montoController.clear();
    });

    // --- ENCHUFE PARA TU AMIGO ---
    // Al registrar un gasto, en Supabase el pedido debe bloquear la opción 
    // de cancelación para el cliente (RF-08).
  }

  void _finalizarCompras() {
    // --- ENCHUFE PARA TU AMIGO ---
    // Cambiar el estado del pedido a "En camino al destino" (RF-09).
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compras terminadas. Iniciando ruta al cliente...')),
    );
    
    // TODO: Navegar a la pantalla de Navegación/Mapa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Compras'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Panel de ingreso de nuevo gasto
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _montoController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Monto exacto (S/)',
                        prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _adjuntarFoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Tomar Foto del Voucher'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _agregarGasto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Agregar Gasto', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            const Text(
              'Gastos Registrados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Lista de compras agregadas
            Expanded(
              child: _comprasRegistradas.isEmpty
                  ? const Center(child: Text('Aún no has registrado compras', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _comprasRegistradas.length,
                      itemBuilder: (context, index) {
                        final compra = _comprasRegistradas[index];
                        return ListTile(
                          leading: const Icon(Icons.receipt_long, color: Colors.blue),
                          title: Text('Voucher #${index + 1}'),
                          subtitle: const Text('Foto adjuntada'),
                          trailing: Text(
                            'S/ ${compra['monto']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        );
                      },
                    ),
            ),
            
            // Botón para finalizar y pasar a la entrega (RF-09)
            ElevatedButton(
              onPressed: _comprasRegistradas.isEmpty ? null : _finalizarCompras,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Compras terminadas, yendo al destino',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}