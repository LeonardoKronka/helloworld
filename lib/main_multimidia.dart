import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
    const TelaTreino(),
    const Center(
      child: Text(
        'Tela de Treinos',
        style: TextStyle(fontSize: 24),
      ),
    ),
    const Center(
      child: Text(
        'Tela de Exercícios',
        style: TextStyle(fontSize: 24),
      ),
    ),
    const Center(
      child: Text(
        'Tela de Perfil',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];

  // Função para abrir o calendário
  void _abrirCalendario() async {
    DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: vermelho,
              onPrimary: Colors.black,
              surface: cardColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataEscolhida != null) {
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

      // MENU SUPERIOR ESQUERDO
      drawer: Drawer(
        backgroundColor: bgDark,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: cardColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: vermelho,
                    size: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Opções',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: const Text(
                'Configurações',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Sair',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
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
        title: const Text(
          'Meu Treino',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            onPressed: _abrirCalendario,
          ),
        ],
      ),

      // Mantém o estado das telas
      body: IndexedStack(
        index: _indiceAtual,
        children: _telas,
      ),

      // ABAS DO RODAPÉ
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bgDark,
        selectedItemColor: vermelho,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _indiceAtual,

        onTap: (index) {
          setState(() {
            _indiceAtual = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercícios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------
// TELA DO TREINO
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
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16,
              ),
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
                  style: TextStyle(
                    color: vermelho,
                  ),
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
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

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
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        ex['feito'] = !ex['feito'];
                      });
                    },

                    child: Icon(
                      Icons.check_circle,
                      color: ex['feito']
                          ? vermelho
                          : Colors.grey[800],
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

              // ÁUDIO INTEGRADO DA MESMA FORMA DO EXEMPLO DO PROFESSOR
              onPressed: () async {
                final player = AudioPlayer();

                await player.play(
                  AssetSource('audio/som.mp3'),
                );
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