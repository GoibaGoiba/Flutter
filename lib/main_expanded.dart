import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Expanded Widget Example")),
        body: Column(
          children: [
            Container(
              height: 100,
              color: Colors.red,
              child: Center(child: Text("Header")),
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "Ocupa todo o espaço restante",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
