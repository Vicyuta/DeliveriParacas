import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Obtenemos la instancia de Supabase que ya configuraste en el main.dart
  final supabase = Supabase.instance.client;

  // Función para insertar un pedido
  Future<void> crearPedidoPrueba() async {
    try {
      await supabase.from('pedidos').insert({
        'id_cliente': '077f1454-ab74-4d58-9d02-1c29670a4311', // <-- Tu UID aquí
        'estado': 'pendiente',
        'direccion_entrega': 'Av. Paracas 123',
        'total': 25.50
        // Nota: Si tu tabla 'pedidos' tiene otras columnas obligatorias, agrégalas aquí.
      });
      print('✅ ¡Pedido insertado con éxito en la base de datos!');
    } catch (error) {
      print('❌ Error al insertar el pedido: $error');
    }
  }
}