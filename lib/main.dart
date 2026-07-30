import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Garante a inicialização correta do motor do Flutter
  WidgetsFlutterBinding.ensureInitialized();
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
        primaryColor: Color(0xFFFFF59D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFFF176),
          primary: Color(0xFFFBC02D),
          secondary: Color(0xFFFFF59D),
          surface: Color(0xFFFFFDE7),
        ),
        useMaterial3: true,
      ),
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int abaSelecionada = 0; 
  int itemMenuSelecionado = 0; 
  List<Map<String, dynamic>> tarefas = [];

  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  String horaSelecionada = "12:00";

  @override
  void initState() {
    super.initState();
    // Carregamento imediato ao iniciar
    _carregarDoBanco();
  }

  // 🔹 LOGICA DE PERSISTENCIA REFORÇADA
  
  Future<void> _carregarDoBanco() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('banco_tarefas_v2');
    
    if (jsonString != null && jsonString.isNotEmpty) {
      setState(() {
        final List<dynamic> listaDecodificada = jsonDecode(jsonString);
        tarefas = listaDecodificada.map((item) => Map<String, dynamic>.from(item)).toList();
      });
      print("Dados carregados com sucesso!");
    }
  }

  Future<void> _salvarNoBanco() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(tarefas);
    await prefs.setString('banco_tarefas_v2', jsonString);
    print("Dados salvos no banco local!");
  }

  List<Map<String, dynamic>> get tarefasFiltradas {
    if (abaSelecionada == 1) {
      return tarefas.where((t) => t["concluida"] == false).toList();
    } else if (abaSelecionada == 2) {
      return tarefas.where((t) => t["concluida"] == true).toList();
    }
    return tarefas;
  }

  void salvarTarefa({int? id}) {
    if (tituloController.text.isNotEmpty) {
      setState(() {
        if (id == null) {
          tarefas.add({
            "id": DateTime.now().millisecondsSinceEpoch,
            "titulo": tituloController.text,
            "hora": horaSelecionada,
            "concluida": false,
            "descricao": descricaoController.text
          });
        } else {
          int index = tarefas.indexWhere((t) => t["id"] == id);
          tarefas[index]["titulo"] = tituloController.text;
          tarefas[index]["hora"] = horaSelecionada;
          tarefas[index]["descricao"] = descricaoController.text;
        }
      });
      _salvarNoBanco(); // Salva imediatamente
      Navigator.pop(context);
    }
  }

  void excluirTarefa(int id) {
    setState(() {
      tarefas.removeWhere((t) => t["id"] == id);
    });
    _salvarNoBanco();
  }

  void mudarStatus(int id, bool? valor) {
    setState(() {
      int index = tarefas.indexWhere((t) => t["id"] == id);
      tarefas[index]["concluida"] = valor;
    });
    _salvarNoBanco();
  }

  void mostrarFormulario({Map<String, dynamic>? tarefa}) {
    if (tarefa != null) {
      tituloController.text = tarefa["titulo"];
      horaSelecionada = tarefa["hora"];
      descricaoController.text = tarefa["descricao"];
    } else {
      tituloController.clear();
      horaSelecionada = "12:00";
      descricaoController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFFFFFDE7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(tarefa == null ? "Nova Tarefa" : "Editar Tarefa", textAlign: TextAlign.center),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: tituloController,
                    decoration: InputDecoration(labelText: "O que fazer?", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? tempo = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (tempo != null) {
                        setDialogState(() {
                          final h = tempo.hour.toString().padLeft(2, '0');
                          final m = tempo.minute.toString().padLeft(2, '0');
                          horaSelecionada = "$h:$m";
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Horário:"),
                          Text(horaSelecionada, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFBC02D))),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: descricaoController,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: "Mais detalhes...", border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
            ElevatedButton(
              onPressed: () => salvarTarefa(id: tarefa?["id"]),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFF176)),
              child: Text("Salvar", style: TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDE7),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF59D),
        elevation: 0,
        centerTitle: true,
        title: Text("Meu Agendador", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: itemMenuSelecionado == 0 ? buildListaTarefas() : buildTelaAjustes(),
      floatingActionButton: itemMenuSelecionado == 0 
        ? FloatingActionButton(
            onPressed: () => mostrarFormulario(),
            backgroundColor: Color(0xFFFFF176),
            child: Icon(Icons.add),
          )
        : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: itemMenuSelecionado,
        onTap: (index) => setState(() => itemMenuSelecionado = index),
        selectedItemColor: Color(0xFFFBC02D),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Tarefas"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ajustes"),
        ],
      ),
    );
  }

  Widget buildListaTarefas() {
    return Column(
      children: [
        Container(
          color: Color(0xFFFFF59D),
          child: Row(
            children: [
              Expanded(child: _buildAbaManual("Todas", 0)),
              Expanded(child: _buildAbaManual("Pendentes", 1)),
              Expanded(child: _buildAbaManual("Concluídas", 2)),
            ],
          ),
        ),
        Expanded(
          child: tarefas.isEmpty 
            ? Center(child: Text("Nenhuma tarefa anotada."))
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: tarefasFiltradas.length,
                itemBuilder: (context, index) {
                  final t = tarefasFiltradas[index];
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Checkbox(
                        value: t["concluida"],
                        onChanged: (v) => mudarStatus(t["id"], v),
                      ),
                      title: Text(
                        t["titulo"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: t["concluida"] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text("${t["hora"]} - ${t["descricao"].toString().length > 50 ? t["descricao"].toString().substring(0, 50) + '...' : t["descricao"]}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(Icons.edit, size: 20), onPressed: () => mostrarFormulario(tarefa: t)),
                          IconButton(icon: Icon(Icons.delete, size: 20, color: Colors.redAccent), onPressed: () => excluirTarefa(t["id"])),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget buildTelaAjustes() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Configurações", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Divider(),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text("Recarregar Dados"),
            onTap: () => _carregarDoBanco(),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text("Limpar Banco de Dados", style: TextStyle(color: Colors.red)),
            onTap: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('banco_tarefas_v2');
              setState(() => tarefas = []);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAbaManual(String texto, int index) {
    bool selecionada = abaSelecionada == index;
    return GestureDetector(
      onTap: () => setState(() => abaSelecionada = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: selecionada ? Border(bottom: BorderSide(color: Color(0xFFFBC02D), width: 3)) : null,
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontWeight: selecionada ? FontWeight.bold : FontWeight.normal,
            color: selecionada ? Colors.black : Colors.black54,
          ),
        ),
      ),
    );
  }
}
