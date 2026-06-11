import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TelaLogin()));

class TelaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela de Login")),
      body: Center(
        child: ElevatedButton(
          child: Text("Entrar"),
          onPressed: () {
            Navigator.pushreplacement(
              context,
              MaterialPageRoute(builder: (context) => TelaHome()),
            );
          },
        ),
      ),
    );
  }
}

class TelaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela Home")),
      body: Center(child: Text("Usuário autenticado com sucesso!")),
    );
  }
}
