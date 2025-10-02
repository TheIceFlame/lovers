import 'package:flutter/material.dart';
import 'package:lover/Widgets/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
const supabaseUrl = 'https://cqrqhdiuzlwbypfxikau.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNxcnFoZGl1emx3YnlwZnhpa2F1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0MzE4NjUsImV4cCI6MjA3NTAwNzg2NX0.RqpErvHKpcaZX_EhgNGm_Fiib5mTUC5NZLK9i6k8Nio';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SY Love',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        fontFamily: 'Poppins', // optional: add Poppins to pubspec for exact look
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            color: Color(0xFF1C1C2E),
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF1C1C2E),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
