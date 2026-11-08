import 'package:flutter/material.dart';

class ClienteSeguimientoScreen extends StatefulWidget {
  final String idPedido;

  const ClienteSeguimientoScreen({super.key, required this.idPedido});

  @override
  State<ClienteSeguimientoScreen> createState() => _ClienteSeguimientoScreenState();
}

class _ClienteSeguimientoScreenState extends State<ClienteSeguimientoScreen> {
  // --- ENCHUFE PARA TU AMIGO (BACKEND) ---
  // Tu compañero usará Supabase Realtime (WebSockets) para actualizar esta lista.
  // Cuando el repartidor agregue un gasto, automáticamente aparecerá aquí.
  final _vouchers = [
    // DESCOMENTA ESTA LÍNEA TEMPORALMENTE PARA VER CÓMO SE BLOQUEA EL BOTÓN DE CANCELAR
    // {'monto': 15.50, 'foto': 'url_simulada'},
  ];
  
  final double _tarifaDelivery = 5.00; // RF-11: Tarifa por kilometraje
  final String _estadoPedido = 'comprando'; // Estados: comprando, en_camino, entregado

  // Lógica matemática para el RF-09
  double get _totalCompras {
    return _vouchers.fold(0, (sum, item) => sum + (item['monto'] as double));
  }

  double get _totalAPagar => _totalCompras + _tarifaDelivery;

  void _abrirChat() {
    // RF-07: Chat interno
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo chat con el repartidor...')),
    );
  }

  void _cancelarPedido() {
    // RF-08: Cancelación de pedido
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cancelando pedido en la base de datos...')),
    );
    // TODO: Regresar a la pantalla de inicio
  }

  @override
  Widget build(BuildContext context) {
    // RF-08: El botón se bloquea automáticamente si la lista de vouchers ya no está vacía.
    final bool puedeCancelar = _vouchers.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento de Pedido'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false, // Oculta la flecha de regresar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Panel de Estado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _estadoPedido == 'comprando' 
                          ? 'El repartidor está realizando tus compras...'
                          : 'El repartidor va en camino a tu ubicación.',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Lista de Vouchers (RF-06)
            const Text('Vouchers de compras:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: _vouchers.isEmpty
                  ? Center(
                      child: Text(
                        'Esperando que el repartidor suba el primer voucher...', 
                        style: TextStyle(color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _vouchers.length,
                      itemBuilder: (context, index) {
                        final v = _vouchers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const Icon(Icons.receipt_long, color: Colors.green),
                            title: Text('Compra #${index + 1}'),
                            subtitle: const Text('Toca para ver foto'),
                            trailing: Text(
                              'S/ ${v['monto'].toStringAsFixed(2)}', 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Resumen de Pagos (RF-09)
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal compras:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('S/ ${_totalCompras.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tarifa de delivery (Km):', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('S/ ${_tarifaDelivery.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total a Pagar:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(
                  'S/ ${_totalAPagar.toStringAsFixed(2)}', 
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botones de acción (RF-07 y RF-08)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _abrirChat,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: puedeCancelar ? _cancelarPedido : null,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}