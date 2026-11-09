import 'dart:io';
import 'package:flutter/material.dart';

class CierreViajeScreen extends StatefulWidget {
  final String idPedido;
  final List compras;
  
  const CierreViajeScreen({super.key, required this.idPedido, required this.compras});

  @override
  State<CierreViajeScreen> createState() => _CierreViajeScreenState();
}

class _CierreViajeScreenState extends State<CierreViajeScreen> {
  final double _tarifaDelivery = 5.00;   
  bool _isLoading = false;

  double get _subtotalCompras {
    return widget.compras.fold(0, (sum, item) => sum + (item['monto'] as double));
  }

  double get _totalACobrar => _subtotalCompras + _tarifaDelivery;

  void _finalizarViaje() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simula Supabase
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Viaje finalizado con éxito!'), backgroundColor: Colors.green),
    );
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _verFoto(File foto) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(foto, fit: BoxFit.contain),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen y Cobro'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            const Text('Has llegado al destino', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Tarjeta de Desglose
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text('DETALLE DE GASTOS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      const Divider(),
                      
                      // Lista desplazable de los vouchers ingresados
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.compras.length,
                          itemBuilder: (context, index) {
                            final c = widget.compras[index];
                            final bool tieneFoto = c['foto'] != null;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: IconButton(
                                icon: Icon(tieneFoto ? Icons.image : Icons.info, color: tieneFoto ? Colors.blue : Colors.orange),
                                onPressed: tieneFoto ? () => _verFoto(c['foto']) : null,
                              ),
                              title: Text('Gasto #${index + 1}'),
                              subtitle: Text(tieneFoto ? 'Ver voucher' : c['justificacion'], style: const TextStyle(fontSize: 12)),
                              trailing: Text('S/ ${(c['monto'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            );
                          },
                        ),
                      ),
                      
                      const Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal Compras:', style: TextStyle(fontSize: 16)),
                          Text('S/ ${_subtotalCompras.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tarifa Delivery:', style: TextStyle(fontSize: 16)),
                          Text('S/ ${_tarifaDelivery.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL A COBRAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            'S/ ${_totalACobrar.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _finalizarViaje,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text('Confirmar Pago y Finalizar', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}