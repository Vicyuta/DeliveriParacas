import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // Función real para insertar un pedido de compras
  Future<void> crearPedidoCompras(String detallesTexto, String direccionEntrega) async {
    try {
      final usuarioActual = supabase.auth.currentUser;
      
      if (usuarioActual == null) {
        throw Exception('No hay un usuario logueado');
      }

      await supabase.from('pedidos').insert({
        'id_cliente': usuarioActual.id,
        'estado': 'buscando', 
        'tipo_pedido': 'compras', 
        'detalle': 'Pedido: $detallesTexto | Entrega: $direccionEntrega', 
        'distancia_km': 0, 
        'precio_total': 0, 
        'ruta_encriptada': 'pendiente_maps', 
        'propina': 0
      });
      
      print('✅ ¡Pedido de compras registrado!');
    } catch (error) {
      print('❌ Error al insertar el pedido: $error');
      rethrow;
    }
  }

  // NUEVA: Función para insertar un pedido de envío
  Future<void> crearPedidoEnvio(String descripcion, String origen, String destino) async {
    try {
      final usuarioActual = supabase.auth.currentUser;
      
      if (usuarioActual == null) throw Exception('No hay un usuario logueado');

      await supabase.from('pedidos').insert({
        'id_cliente': usuarioActual.id,
        'estado': 'buscando',
        'tipo_pedido': 'envio', // Cambiamos el tipo a 'envio'
        'detalle': 'Paquete: $descripcion | Recojo: $origen | Entrega: $destino',
        'distancia_km': 0, 
        'precio_total': 0, 
        'ruta_encriptada': 'pendiente_maps', 
        'propina': 0
      });
      print('✅ ¡Pedido de envío registrado!');
    } catch (error) {
      print('❌ Error al insertar el envío: $error');
      rethrow;
    }
  }
}