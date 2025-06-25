import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/referanslar_page.dart';
import 'screens/referans_duzenle_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Referans Takip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/referanslar': (context) => const ReferanslarPage(),
        '/referansDuzenle': (context) => const ReferansDuzenlePage(),
      },
    );
  }
}
