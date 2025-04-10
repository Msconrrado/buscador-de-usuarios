import 'package:flutter/material.dart';
import 'screens/user_finder_page.dart'; 

void main() {
  runApp(const BuscadorDeUsuariosApp());
}

class BuscadorDeUsuariosApp extends StatelessWidget {
  const BuscadorDeUsuariosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscador de Usuários',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        textTheme: const TextTheme(bodyMedium: TextStyle(fontFamily: 'Roboto')),
      ),
      home: const UserFinderPage(),
    );
  }
}