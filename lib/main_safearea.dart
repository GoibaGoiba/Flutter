import 'package:flutter/material.dart';

void main() {
  runApp(SafeAreaExample());
}

class SafeAreaExample extends StatelessWidget {
  const SafeAreaExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("SafeArea Example")),
        body: SafeArea(
          child: Column(
            children: [
              const Text("Aplicação Flutter", style: TextStyle(fontSize: 24)),
              Text("Conteúdo protegido da barra de status"),
            ],
          ),
        ),
      ),
    );
  }
}
