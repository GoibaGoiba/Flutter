import 'package:flutter/material.dart';

// Ponto de entrada do aplicativo
void main() {
  runApp(MeuAgendadorApp());
}

class MeuAgendadorApp extends StatelessWidget {
  const MeuAgendadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agendador de Tarefas',
      theme: ThemeData(
        // Tema em tons pastéis amarelados conforme solicitado
        primaryColor: Color(0xFFFFF59D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFFF176),
          primary: Color(0xFFFBC02D),
          secondary: Color(0xFFFFF59D),
          surface: Color(0xFFFFFDE7),
        ),
        useMaterial3: true,
      ),
      home: TelaMinhasTarefas(),
    );
  }
}

// TELA PRINCIPAL - Demonstra Listas Dinâmicas, Diálogos e Feedback
class TelaMinhasTarefas extends StatefulWidget {
  const TelaMinhasTarefas({super.key});

  @override
  _TelaMinhasTarefasState createState() => _TelaMinhasTarefasState();
}

class _TelaMinhasTarefasState extends State<TelaMinhasTarefas> {
  // Dados das tarefas (Tópico: Listas Dinâmicas)
  List<Map<String, dynamic>> tarefas = [
    {"titulo": "Estudar Flutter", "hora": "10:00", "concluida": true, "descricao": "Revisar widgets básicos e estado."},
    {"titulo": "Reunião com equipe", "hora": "14:00", "concluida": false, "descricao": "Definir metas da semana."},
    {"titulo": "Enviar relatório", "hora": "15:30", "concluida": false, "descricao": "Relatório de desempenho mensal."},
  ];

  final tarefaController = TextEditingController();

  // Função para adicionar (Tópico: Entrada de Dados e Processamento)
  void adicionarTarefa() {
    if (tarefaController.text.isNotEmpty) {
      setState(() {
        tarefas.add({
          "titulo": tarefaController.text,
          "hora": "12:00",
          "concluida": false,
          "descricao": "Tarefa adicionada manualmente."
        });
        tarefaController.clear();
      });
      Navigator.pop(context);
      
      // Feedback visual (Tópico: Feedback / SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tarefa adicionada com sucesso"),
          backgroundColor: Color(0xFFFBC02D),
        ),
      );
    }
  }

  // Diálogo de confirmação para excluir (Tópico: Diálogos / AlertDialog)
  void confirmarExclusao(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Excluir tarefa?"),
          content: Text("Deseja realmente remover esta tarefa da lista?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Não"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tarefas.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Tarefa removida")),
                );
              },
              child: Text("Sim", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Janela para nova tarefa (Tópico: Menus e Diálogos)
  void mostrarDialogoAdicionar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFDE7),
          title: Text("Nova Tarefa"),
          content: TextField(
            controller: tarefaController,
            decoration: InputDecoration(
              labelText: "Título da tarefa",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: adicionarTarefa,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFF176)),
              child: Text("Salvar", style: TextStyle(color: Colors.black87)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDE7),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF59D),
        centerTitle: true,
        title: Text("Minhas Tarefas", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: mostrarDialogoAdicionar,
          ),
        ],
      ),
      body: Column(
        children: [
          // Abas superiores (Simulação de Menus/Filtros)
          Container(
            color: Color(0xFFFFF59D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAba("Todas", true),
                _buildAba("Pendentes", false),
              ],
            ),
          ),

          // Lista de tarefas (Tópico: Listas Dinâmicas / ListView.builder)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Checkbox(
                      activeColor: Color(0xFFFBC02D),
                      value: tarefa["concluida"],
                      onChanged: (valor) {
                        setState(() {
                          tarefas[index]["concluida"] = valor;
                        });
                      },
                    ),
                    title: Text(
                      tarefa["titulo"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: tarefa["concluida"] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text("Hoje às ${tarefa["hora"]}"),
                    onTap: () {
                      // Tópico: Navegação entre telas (Navigator.push)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaDetalhes(tarefa: tarefa),
                        ),
                      );
                    },
                    onLongPress: () => confirmarExclusao(index), // Tópico: Diálogos
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: mostrarDialogoAdicionar,
        backgroundColor: Color(0xFFFFF176),
        child: Icon(Icons.add),
      ),
      // Tópico: Navegação (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFFBC02D),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: "Tarefas"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ajustes"),
        ],
      ),
    );
  }

  Widget _buildAba(String texto, bool selecionada) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: selecionada ? Border(bottom: BorderSide(color: Color(0xFFFBC02D), width: 3)) : null,
      ),
      child: Text(
        texto,
        style: TextStyle(fontWeight: selecionada ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}

// SEGUNDA TELA - Demonstra Navegação e Passagem de Dados
class TelaDetalhes extends StatelessWidget {
  final Map<String, dynamic> tarefa;

  const TelaDetalhes({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text("Detalhes da Tarefa"),
        backgroundColor: Color(0xFFFFF59D),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tarefa["titulo"],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFBC02D)),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey),
                SizedBox(width: 5),
                Text("Horário marcado: ${tarefa["hora"]}"),
              ],
            ),
            Divider(height: 30),
            Text(
              "Descrição:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              tarefa["descricao"],
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Tópico: Navegação (Navigator.pop)
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFF176)),
                child: Text("Voltar para Lista", style: TextStyle(color: Colors.black87)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* 
  NOTA SOBRE PERSISTÊNCIA (Tópico 6 das apresentações):
  Para implementar o SharedPreferences como o professor mostrou, 
  seria necessário adicionar a dependência no pubspec.yaml.
  O código seguiria esta lógica:
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('lista_tarefas', jsonEncode(tarefas));
*/
