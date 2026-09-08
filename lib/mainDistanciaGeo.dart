import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Distância até minha casa',
      home: const LocalizacaoPage(),
    );
  }
}

class LocalizacaoPage extends StatefulWidget {
  const LocalizacaoPage({super.key});

  @override
  State<LocalizacaoPage> createState() => _LocalizacaoPageState();
}

class _LocalizacaoPageState extends State<LocalizacaoPage> {
  double latitude = 0;
  double longitude = 0;
  double? distanciaMetros;
  String mensagem = 'Toque no botão para obter sua localização.';

  static const double latitudeCasa = -21.45146630442073;
  static const double longitudeCasa = -47.0071411853013;

  Future<void> buscarLocalizacao() async {
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      setState(() {
        mensagem = 'Ative o serviço de localização do celular.';
      });
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      setState(() {
        mensagem = 'Permissão de localização não concedida.';
      });
      return;
    }

    final Position posicao = await Geolocator.getCurrentPosition();

    final double distancia = Geolocator.distanceBetween(
      posicao.latitude,
      posicao.longitude,
      latitudeCasa,
      longitudeCasa,
    );

    setState(() {
      latitude = posicao.latitude;
      longitude = posicao.longitude;
      distanciaMetros = distancia;
      mensagem = 'Localização atualizada com sucesso.';
    });

    print('Distância até casa: $distanciaMetros metros');
  }

  String formatarDistancia(double metros) {
    if (metros < 1000) {
      return '${metros.toStringAsFixed(2)} metros';
    }

    final double quilometros = metros / 1000;
    return '${quilometros.toStringAsFixed(2)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Distância até minha casa')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                'Localização atual',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              Text(
                distanciaMetros == null
                    ? 'Distância até casa: ainda não calculada'
                    : 'Distância até casa: ${formatarDistancia(distanciaMetros!)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(mensagem, textAlign: TextAlign.center),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: buscarLocalizacao,
                child: const Text('Calcular distância'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
