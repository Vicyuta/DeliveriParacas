import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'registrar_compra_screen.dart';
import '../supabase_service.dart'; // Importamos el servicio

class RepartidorHomeScreen extends StatefulWidget {
  const RepartidorHomeScreen({super.key});

  @override
  State<RepartidorHomeScreen> createState() => _RepartidorHomeScreenState();
}

class _RepartidorHomeScreenState extends State<RepartidorHomeScreen> {
  bool _isActivo = false;
  final _servicio = SupabaseService();

  @override
  void initState() {
    super.initState();
    _cargarEstadoInicial();
  }

  // Consulta la base de datos al abrir la app para ver si ya estaba activo
  Future<void> _cargarEstadoInicial() async {
    try {
      final usuario = Supabase.instance.client.auth.currentUser;
      if (usuario != null) {
        final data = await Supabase.instance.client
            .from('usuarios')
            .select('is_activo')
            .eq('id', usuario.id)
            .single();
            
        if (mounted) {
          setState(() {
            _isActivo = data['is_activo'] ?? false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error cargando estado: $e');
    }
  }

  Future<void> _toggleActivo(bool valor) async {
    // Actualización visual inmediata
    setState(() {
      _isActivo = valor;
    });
    
    try {
      // Actualización en la base de datos
      await _servicio.actualizarEstadoActivo(valor);
    } catch (e) {
      // Si falla la red, regresamos el switch a su posición original
      if (mounted) {
        setState(() {
          _isActivo = !valor;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de conexión al cambiar estado')),
        );
      }
    }
  }

  Future<void> _aceptarPedido(String idPedido) async {
    try {
      // Usamos la nueva función del servicio que inserta el ID del motorizado
      await _servicio.aceptarPedido(idPedido);

      if (!mounted) return;

      // Navegamos hacia la pantalla de registro de compras
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrarCompraScreen(idPedido: idPedido),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al aceptar pedido: $e')),
      );
    }
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
                activeThumbColor: Colors.green,
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
          : StreamBuilder(
              stream: Supabase.instance.client
                  .from('pedidos')
                  .stream(primaryKey: ['id'])
                  .eq('estado', 'buscando'), 
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final List pedidos = (snapshot.data as List?) ?? [];

                if (pedidos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay pedidos buscando repartidor',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];
                    
                    final idPedido = pedido['id'].toString();
                    final tipo = pedido['tipo_pedido'] ?? 'Delivery'; 
                    final descripcion = pedido['detalle'] ?? 'Sin descripción';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                    tipo.toString().toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: tipo == 'compras' ? Colors.orange : Colors.blue,
                                ),
                                Text(
                                  '${pedido['distancia_km'] ?? 0} km',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              descripcion,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _aceptarPedido(idPedido),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Aceptar Pedido', style: TextStyle(fontSize: 16, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}