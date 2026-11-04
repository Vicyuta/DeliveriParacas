import 'package:flutter/material.dart';

class BuscandoRepartidorScreen extends StatefulWidget {
  const BuscandoRepartidorScreen({super.key});

  @override
  State<BuscandoRepartidorScreen> createState() => _BuscandoRepartidorScreenState();
}

class _BuscandoRepartidorScreenState extends State<BuscandoRepartidorScreen> {
  
  @override
  void initState() {
    super.initState();
    // --- ENCHUFE PARA TU AMIGO (BACKEND) ---
    // Aquí tu compañero debe iniciar un 'stream' (escucha en tiempo real con WebSockets) a Supabase.
    // El sistema debe quedarse esperando a que algún repartidor cambie el estado de este pedido a 'aceptado'.
    // Cuando eso ocurra, el código de tu amigo automáticamente ejecutará algo como esto:
    // if (pedido.estado == 'aceptado') {
    //   Navigator.pushReplacementNamed(context, '/seguimiento_pedido');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Animación visual del radar
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              const Text(
                'Buscando repartidor...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Estamos enviando tu lista de compras a los repartidores activos en Paracas.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              
              const Spacer(),
              
              // Botón de Cancelar Pedido (RF-08)
              OutlinedButton(
                onPressed: () {
                  // --- ENCHUFE PARA TU AMIGO ---
                  // Aquí conectará la función para eliminar o marcar como 'cancelado' el pedido en Supabase
                  Navigator.pop(context); // Regresa a la pantalla de compras
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Cancelar Pedido',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}