import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Minha Tela",
            style: TextStyle(color: Colors.deepPurpleAccent),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.thumb_up, size: 60, color: Colors.deepPurpleAccent),

              SizedBox(width: 20, height: 20),

              Text(
                "D.S. é o melhor curso do SESI?",
                style: TextStyle(fontSize: 22, color: Colors.deepPurpleAccent),
              ),

              SizedBox(width: 20, height: 20),

              ElevatedButton(
                onPressed: () {
                  print("Usuário clicou");
                },
                child: Text("Curtir"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
