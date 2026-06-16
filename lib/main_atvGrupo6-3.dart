import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(IdiomaApp());
}

// - - - - - - - Classe principal do aplicativo - - - - - - -
class IdiomaApp extends StatefulWidget {
  const IdiomaApp({super.key});

  @override
  State<IdiomaApp> createState() => _IdiomaAppState();
}

// - - - - - - - Classe responsável pela lógica - - - - - - -
class _IdiomaAppState extends State<IdiomaApp> {
  // Variável responsável por controlar o idioma
  // true  -> inglês
  // false -> português
  // O aplicativo começa em português
  bool isEnglish = false;

  @override
  void initState() {
    super.initState();
    carregarIdioma();
  }

  // - - - - - - - Função para salvar o idioma - - - - - - -
  Future<void> salvarIdioma(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('idiomaIngles', valor);
  }

  // - - - - - - - Função para carregar idioma - - - - - - -
  Future<void> carregarIdioma() async {
    final prefs = await SharedPreferences.getInstance();
    bool? idiomaSalvo = prefs.getBool('idiomaIngles');

    setState(() {
      isEnglish = idiomaSalvo ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),

      // - - - - - - - Tela Principal - - - - - - -
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            isEnglish ? "Language Settings" : "Configurações de Idioma",
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Texto mostrando o idioma atual
              Text(
                isEnglish ? "English" : "Português",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Texto de exemplo para mostrar a tradução
              Text(
                isEnglish ? "Hello, User!" : "Olá, Usuário!",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // - - - - - - - Botão Português (BR) - - - - - - -
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEnglish = false;
                      });
                      salvarIdioma(false);
                    },
                    child: const Text(
                      "🇧🇷 PT",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // SWITCH
                  Switch(
                    value: isEnglish,
                    onChanged: (valor) {
                      setState(() {
                        isEnglish = valor;
                      });
                      salvarIdioma(valor);
                    },
                  ),

                  const SizedBox(width: 10),

                  // - - - - - - - Botão Inglês (US) - - - - - - -
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEnglish = true;
                      });
                      salvarIdioma(true);
                    },
                    child: const Text(
                      "🇺🇸 EN",
                      style: TextStyle(fontSize: 24),
                    ),
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
