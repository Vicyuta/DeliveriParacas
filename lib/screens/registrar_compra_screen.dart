import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'cierre_viaje_screen.dart';

class RegistrarCompraScreen extends StatefulWidget {
  final String idPedido;
  
  const RegistrarCompraScreen({super.key, required this.idPedido});

  @override
  State<RegistrarCompraScreen> createState() => _RegistrarCompraScreenState();
}

class _RegistrarCompraScreenState extends State<RegistrarCompraScreen> {
  final _montoController = TextEditingController();
  final _justificacionController = TextEditingController();
  
  File? _fotoVoucher;
  bool _mostrarJustificacion = false; // Controla si se ve el campo de texto
  final _comprasRegistradas = [];

  Future<void> _tomarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (foto != null) {
      setState(() {
        _fotoVoucher = File(foto.path);
        _mostrarJustificacion = false; // Oculta justificación si ya hay foto
        _justificacionController.clear();
      });
    }
  }

  void _agregarGasto() {
    if (_montoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el monto de la compra')),
      );
      return;
    }

    // Si no hay foto y la justificación está vacía, mostramos el campo
    if (_fotoVoucher == null && _justificacionController.text.trim().isEmpty) {
      setState(() {
        _mostrarJustificacion = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes enviar una foto del voucher o escribir una justificación.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _comprasRegistradas.add({
        'monto': double.parse(_montoController.text),
        'foto': _fotoVoucher,
        'justificacion': _justificacionController.text.trim(),
      });
      
      _montoController.clear();
      _justificacionController.clear();
      _fotoVoucher = null;
      _mostrarJustificacion = false;
    });
  }

  void _finalizarCompras() {
    // Enviamos la lista real de compras a la pantalla de boleta
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CierreViajeScreen(
          idPedido: widget.idPedido,
          compras: _comprasRegistradas, // Pasamos los datos
        ),
      ),
    );
  }

  // Permite ver la foto del voucher en grande si la tocan en la lista
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
                    
                    if (_fotoVoucher == null)
                      OutlinedButton.icon(
                        onPressed: _tomarFoto,
                        icon: const Icon(Icons.camera_alt, color: Colors.blue),
                        label: const Text('Tomar Foto del Voucher', style: TextStyle(color: Colors.blue)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    else
                      Column(
                        children: [
                          const Text('Voucher capturado:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              GestureDetector(
                                onTap: () => _verFoto(_fotoVoucher!),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(_fotoVoucher!, height: 100, width: double.infinity, fit: BoxFit.cover),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red, size: 30),
                                onPressed: () => setState(() => _fotoVoucher = null), // Borrar foto
                              ),
                            ],
                          ),
                        ],
                      ),

                    const SizedBox(height: 12),
                    
                    if (_mostrarJustificacion)
                      TextField(
                        controller: _justificacionController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Justificación (Ej: Pasaje colectivo)',
                          prefixIcon: const Icon(Icons.edit_note, color: Colors.orange),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(12)),
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
            const Text('Gastos Registrados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            Expanded(
              child: _comprasRegistradas.isEmpty
                  ? const Center(child: Text('Aún no has registrado compras', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _comprasRegistradas.length,
                      itemBuilder: (context, index) {
                        final compra = _comprasRegistradas[index];
                        final bool tieneFoto = compra['foto'] != null;
                        
                        return ListTile(
                          leading: Icon(
                            tieneFoto ? Icons.image : Icons.receipt_long, 
                            color: tieneFoto ? Colors.green : Colors.orange
                          ),
                          title: Text('Gasto #${index + 1} - S/ ${compra['monto']}'),
                          subtitle: Text(
                            tieneFoto ? 'Toca para ver foto' : 'Justificación: ${compra['justificacion']}',
                          ),
                          onTap: tieneFoto ? () => _verFoto(compra['foto']) : null, // Ver foto al tocar la lista
                        );
                      },
                    ),
            ),
            
            ElevatedButton(
              onPressed: _comprasRegistradas.isEmpty ? null : _finalizarCompras,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Compras terminadas, yendo al destino', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}