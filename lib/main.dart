import 'package:flutter/material.dart';
import 'package:aku_bisa_ukl/views/splash_screen.dart';
import 'package:aku_bisa_ukl/views/library_view.dart';
import 'package:aku_bisa_ukl/views/linimasa_view.dart';
import 'package:aku_bisa_ukl/views/profile_view.dart';
import 'package:aku_bisa_ukl/views/login.dart';
import 'package:aku_bisa_ukl/controllers/library_controller.dart';

final LibraryController sharedLibraryController = LibraryController();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      initialRoute: '/splash', 
      routes: {
        '/splash': (context) => const SplashView(),
        '/login': (context) => const LoginView(), 
        '/': (context) => const LibraryView(), 
        '/linimasa': (context) => const LinimasaView(),
        '/profile': (context) => ProfileView(),
      },
    );
  }
}