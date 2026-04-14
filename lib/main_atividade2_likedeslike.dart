import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ContadorTela());
  }
}

class ContadorTela extends StatefulWidget {
  const ContadorTela({super.key});

  @override
  _ContadorTelaState createState() => _ContadorTelaState();
}

class _ContadorTelaState extends State<ContadorTela> {
  int contador = 0;

  void incrementar() {
    setState(() {
      contador++;
    });
  }

  void decrementar() {
    setState(() {
      if (contador > 0) {
        contador--;
      }
      if (contador == 0) {
        contador;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            "https://i.pinimg.com/736x/19/6e/87/196e87cbc422ebb54aa898462b3ddc98.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Aplicativo de Curtidas"),
          centerTitle: true,
          backgroundColor: Colors.white.withValues(alpha: 0.3),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Icon(
                Icons.currency_yen_sharp,
                color: Colors.yellow,
                size: 80,
                shadows: [
                  Shadow(
                    color: Colors.deepPurple.withValues(alpha: 0.8),
                    offset: Offset(0, 4.0),
                    blurRadius: 15.0,
                  ),
                ],
              ),

              SizedBox(height: 20),

              Text(
                "$contador Curtidas",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    onPressed: incrementar,
                    icon: Icon(Icons.thumb_up, color: Colors.green.shade700),
                    label: const Text("Curtir"),
                    backgroundColor: Colors.greenAccent.shade100,
                    foregroundColor: Colors.black,
                  ),

                  SizedBox(width: 10),

                  FloatingActionButton.extended(
                    onPressed: decrementar,
                    icon: Icon(Icons.thumb_down, color: Colors.red.shade900),
                    label: const Text("Descurtir"),
                    backgroundColor: Colors.redAccent.shade100,
                    foregroundColor: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}