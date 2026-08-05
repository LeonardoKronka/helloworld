import 'package:flutter/material.dart';

void main() {
  runApp(const MeuTreinoApp());
}

// Cores Globais do App
const Color vermelho = Color.fromARGB(255, 255, 20, 20);
const Color bgDark = Color(0xFF121212);
const Color cardColor = Color(0xFF1E1E1E);

class MeuTreinoApp extends StatelessWidget {
  const MeuTreinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Treino',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgDark,
      ),
      home: const TelaPrincipal(),
    );
  }
}

// ---------------------------------------------------
// TELA PRINCIPAL (Gerencia Abas, Menu Lateral e Calendário)
// ---------------------------------------------------
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _indiceAtual = 0;

  // Lista de telas para cada aba do rodapé
  final List<Widget> _telas = [
    const TelaTreino(), // Aba 0: Início
    const Center(
      child: Text('Tela de Treinos', style: TextStyle(fontSize: 24)),
    ), // Aba 1
    const Center(
      child: Text('Tela de Exercícios', style: TextStyle(fontSize: 24)),
    ), // Aba 2
    const Center(
      child: Text('Tela de Perfil', style: TextStyle(fontSize: 24)),
    ), // Aba 3
  ];

  // Função para abrir o calendário customizado com o tema Neon
  void _abrirCalendario() async {
    DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        // Racional: Estilizar o calendário para não quebrar a imersão do app
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: vermelho,
              onPrimary: Colors.black, // Cor do texto no botão do calendário
              surface: cardColor, // Fundo do calendário
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataEscolhida != null) {
      // Aqui você pode fazer algo com a data, como buscar o treino do dia escolhido no banco de dados
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Data selecionada: ${dataEscolhida.day}/${dataEscolhida.month}/${dataEscolhida.year}',
          ),
          backgroundColor: cardColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. MENU SUPERIOR ESQUERDO (Drawer)
      drawer: Drawer(
        backgroundColor: bgDark,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: cardColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.fitness_center, color: vermelho, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Opções',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Configurações',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context), // Fecha o menu
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
              title: const Text(
                'Sair',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // O Flutter já coloca o ícone de hambúrguer automaticamente porque temos um "drawer" definido.
        // Se quiser forçar o seu ícone, use um Builder para acionar Scaffold.of(context).openDrawer()
        title: const Text(
          'Meu Treino',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          // 2. CALENDÁRIO NO TOPO DIREITO
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            onPressed: _abrirCalendario,
          ),
        ],
      ),

      // O IndexedStack mantém o estado das telas vivo em segundo plano
      body: IndexedStack(index: _indiceAtual, children: _telas),

      // 3. ABAS DO RODAPÉ (Funcionais)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bgDark,
        selectedItemColor: vermelho,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType
            .fixed, // Necessário quando há mais de 3 itens
        currentIndex: _indiceAtual,
        onTap: (index) {
          setState(() {
            _indiceAtual = index; // Troca a aba ativa
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercícios',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------
// TELA DO TREINO (Aba 0)
// ---------------------------------------------------
class TelaTreino extends StatefulWidget {
  const TelaTreino({super.key});

  @override
  State<TelaTreino> createState() => _TelaTreinoState();
}

class _TelaTreinoState extends State<TelaTreino> {
  final List<Map<String, dynamic>> exercicios = [
    {
      'nome': 'Supino Reto',
      'series': '4 séries x 10 repetições',
      'feito': false,
    },
    {
      'nome': 'Puxada na Frente',
      'series': '4 séries x 12 repetições',
      'feito': false,
    },
    {
      'nome': 'Desenvolvimento',
      'series': '3 séries x 10 repetições',
      'feito': false,
    },
    {
      'nome': 'Rosca Direta',
      'series': '3 séries x 12 repetições',
      'feito': false,
    },
    {
      'nome': 'Tríceps na Polia',
      'series': '3 séries x 12 repetições',
      'feito': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 16),
              children: [
                TextSpan(
                  text: 'Segunda-feira - ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Membros Superiores',
                  style: TextStyle(color: vermelho),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: exercicios.length,
            itemBuilder: (context, index) {
              final ex = exercicios[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ex['feito']
                        ? vermelho.withOpacity(0.5)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.white54,
                    ),
                  ),
                  title: Text(
                    ex['nome'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    ex['series'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        ex['feito'] = !ex['feito']; // Marca/desmarca
                      });
                    },
                    child: Icon(
                      Icons.check_circle,
                      color: ex['feito'] ? vermelho : Colors.grey[800],
                      size: 32,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: vermelho,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Ação de finalizar treino
              },
              child: const Text(
                'Finalizar Treino',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
