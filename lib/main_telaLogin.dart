import 'package:flutter/material.dart';
import 'package:hello_world/main_MediaQuery.dart';

void main() {
  runApp(MediaQueryExample());
}

class MediaQueryExample extends StatelessWidget {
  const MediaQueryExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "MediaQuery", home: const HomeScreen());
  }
}

class SafeAreaExample extends StatelessWidget {
  const SafeAreaExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 100, color: Colors.blue),
                  SizedBox(height: 16),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: largura * 0.85,
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: largura * 0.85,
                    height: 60,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(largura * 0.85, 60),
                    ),
                    child: Text("Entrar"),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(largura * 0.85, 60),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text("Criar Conta"),
                  ),
                  SizedBox(height: 1000), // Para testar o scroll
                  ElevatedButton(onPressed: () {}, child: Text("")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
