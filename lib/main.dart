import 'package:flutter/material.dart';

void main() {
  runApp(MediaQueryExample());
}

class MediaQueryExample extends StatelessWidget {
  const MediaQueryExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MediaQuery Example', home: const HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('MediaQuery Example')),
      body: Center(
        child: Container(
          height: largura * 0.8,
          width: 120,
          color: Colors.green,
          child: const Center(
            child: Text(
              "Container com altura baseada na largura da tela",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
