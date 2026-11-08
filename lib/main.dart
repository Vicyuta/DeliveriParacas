import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/cliente_home_screen.dart'; // <-- Agregamos el import del Home

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dxrnngkvpdzrhfilzgqy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4cm5uZ2t2cGR6cmhmaWx6Z3F5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM1NzE2OTgsImV4cCI6MjEwOTE0NzY5OH0.RnwGsfcfFDNBy0JUJQIlZg6Ez2VhfZ2s_KV2j-wzMdY', // <-- Mantén tu clave real aquí
  );

  runApp(const MiDeliveryApp());
}

class MiDeliveryApp extends StatelessWidget {
  const MiDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Paracas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF2F2F2),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      // En lugar de ir ciegamente al login, usamos nuestro guardia
      home: const AuthGate(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

// --- ESTE ES EL NUEVO GUARDIA ---
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Verificamos si Supabase tiene una sesión guardada en la memoria del celular
    final sesionActual = Supabase.instance.client.auth.currentSession;

    // Si hay sesión, lo mandamos directo al Home. Si no, lo mandamos al Login.
    if (sesionActual != null) {
      return const ClienteHomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}