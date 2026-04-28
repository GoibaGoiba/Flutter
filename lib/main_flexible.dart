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
        appBar: AppBar(title: Text("Flexible Example")),
        body: Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: 100,
                color: Colors.red,
                child: Center(child: Text("Flex 1")),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                height: 100,
                color: Colors.blue,
                child: Center(child: Text("Flex 2")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
