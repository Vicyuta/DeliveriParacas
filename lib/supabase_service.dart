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

  // Función para insertar un pedido de envío
  Future<void> crearPedidoEnvio(String descripcion, String origen, String destino) async {
    try {
      final usuarioActual = supabase.auth.currentUser;
      
      if (usuarioActual == null) throw Exception('No hay un usuario logueado');

      await supabase.from('pedidos').insert({
        'id_cliente': usuarioActual.id,
        'estado': 'buscando',
        'tipo_pedido': 'envio',
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

  // NUEVA: Función para que el repartidor acepte el pedido y registre su ID
  Future<void> aceptarPedido(String idPedido) async {
    try {
      final usuarioActual = supabase.auth.currentUser;
      if (usuarioActual == null) throw Exception('No hay un usuario logueado');

      await supabase.from('pedidos').update({
        'estado': 'en_camino',
        'id_repartidor': usuarioActual.id // Aquí llenamos el campo NULL
      }).eq('id', idPedido);
      
    } catch (error) {
      print('❌ Error al aceptar el pedido: $error');
      rethrow;
    }
  }

  // NUEVA: Función para actualizar si el repartidor está trabajando o no
  Future<void> actualizarEstadoActivo(bool isActivo) async {
    try {
      final usuarioActual = supabase.auth.currentUser;
      if (usuarioActual == null) throw Exception('No hay un usuario logueado');

      await supabase.from('usuarios').update({
        'is_activo': isActivo
      }).eq('id', usuarioActual.id);
      
    } catch (error) {
      print('❌ Error al cambiar estado: $error');
      rethrow;
    }
  }
}