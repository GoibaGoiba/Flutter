import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: TelaValidacao()));
}

// ==================== FUNÇÃO COM VALIDAÇÃO E THROW EXCEPTION ====================

double calcularDesconto(double valorOriginal, double porcentagem) {
  // Validação usando operador lógico OR (||)
  // Verifica se porcentagem < 0 OU porcentagem > 100
  if (porcentagem < 0 || porcentagem > 100) {
    throw Exception(
      'Erro: Porcentagem deve estar entre 0 e 100. '
      'Valor recebido: $porcentagem',
    );
  }

  // Validação do valor original
  if (valorOriginal < 0) {
    throw Exception(
      'Erro: Valor original não pode ser negativo. '
      'Valor recebido: $valorOriginal',
    );
  }

  // Cálculo do desconto
  double desconto = valorOriginal * (porcentagem / 100);
  double valorFinal = valorOriginal - desconto;

  return valorFinal;
}

// ==================== WIDGET PARA DEMONSTRAÇÃO ====================

class TelaValidacao extends StatefulWidget {
  const TelaValidacao({super.key});

  @override
  State<TelaValidacao> createState() => _TelaValidacaoState();
}

class _TelaValidacaoState extends State<TelaValidacao> {
  String resultado = 'Digite os valores e clique em Calcular';
  final controladorValor = TextEditingController();
  final controladorPorcentagem = TextEditingController();

  // ==================== EXEMPLO DE TRY-CATCH ====================

  void executarCalculo() {
    try {
      // TRY: Tenta executar o código que pode gerar exceção
      double valor = double.parse(controladorValor.text);
      double porcentagem = double.parse(controladorPorcentagem.text);

      // Chama a função que valida e pode lançar exceção
      double resultado = calcularDesconto(valor, porcentagem);

      // Se não houver erro, exibe o resultado
      setState(() {
        this.resultado =
            'Valor com desconto: R\$ ${resultado.toStringAsFixed(2)}';
      });

      // CATCH: Captura a exceção lançada pela função
    } on Exception catch (e) {
      setState(() {
        resultado = 'EXCEÇÃO CAPTURADA: ${e.toString()}';
      });

      // FINALLY: Executa sempre, com ou sem erro
    } finally {
      print('Cálculo finalizado');
    }
  }

  // ==================== ESTRUTURA DA INTERFACE ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validação de Dados e Exceções')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de entrada: Valor Original
            TextField(
              controller: controladorValor,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor Original (R\$)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Ex: 100.00',
              ),
            ),
            const SizedBox(height: 20),

            // Campo de entrada: Porcentagem
            TextField(
              controller: controladorPorcentagem,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Porcentagem de Desconto (%)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Ex: 10 (válido: 0-100)',
              ),
            ),
            const SizedBox(height: 30),

            // Botão para executar cálculo (dispara try-catch)
            ElevatedButton(
              onPressed: executarCalculo,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Calcular Desconto',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),

            // Exibição do resultado
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                resultado,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Seção de Informações Pedagógicas
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Conceitos Demonstrados:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildConceito(
                    'Validação com Operador OR (||):',
                    'porcentagem < 0 || porcentagem > 100',
                  ),
                  const SizedBox(height: 8),
                  _buildConceito(
                    'Lançamento de Exceção (throw):',
                    'throw Exception(...)',
                  ),
                  const SizedBox(height: 8),
                  _buildConceito(
                    'Captura de Exceção (try-catch):',
                    'Trata erros sem crash da aplicação',
                  ),
                  const SizedBox(height: 8),
                  _buildConceito(
                    'Resiliência:',
                    'App continua funcionando após erro',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para exibir conceitos
  Widget _buildConceito(String titulo, String descricao) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          descricao,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controladorValor.dispose();
    controladorPorcentagem.dispose();
    super.dispose();
  }
}
