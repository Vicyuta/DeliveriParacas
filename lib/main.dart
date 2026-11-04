import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  // Asegura que los widgets de Flutter se inicialicen antes de servicios externos
  WidgetsFlutterBinding.ensureInitialized();

  // Conecta la app con tu proyecto en Supabase (Código de tu compañero)
  await Supabase.initialize(
    url: 'https://dxrnngkvpdzrhfilzgqy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4cm5uZ2t2cGR6cmhmaWx6Z3F5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM1NzE2OTgsImV4cCI6MjEwOTE0NzY5OH0.RnwGsfcfFDNBy0JUJQIlZg6Ez2VhfZ2s_KV2j-wzMdY',
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
      // Aquí indicamos que la app arranque en el Login (RF-01)
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}