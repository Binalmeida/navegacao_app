import 'package:flutter/material.dart';
import 'models/produto.dart';
import 'screens/detail_screen.dart';
import 'screens/add_product_screen.dart';

void main() {
  runApp(const NavegacaoApp());
}

class NavegacaoApp extends StatelessWidget {
  const NavegacaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Navegação',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),

      home: const HomeScreen(),

      routes: {
        '/cadastro': (context) => const AddProductScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/detalhes') {
          final produto = settings.arguments as Produto;

          return MaterialPageRoute(
            builder: (context) {
              return DetailScreen(
                produto: produto,
              );
            },
          );
        }

        return null;
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Produto> _produtos = [
    Produto(
      nome: 'Notebook Pro',
      descricao:
          'Processador de última geração, 16GB RAM, SSD 512GB.',
      preco: 4500.00,
    ),
    Produto(
      nome: 'Smartphone X',
      descricao:
          'Tela AMOLED 120Hz, Câmera Tripla de 50MP.',
      preco: 2800.00,
    ),
    Produto(
      nome: 'Fone Bluetooth',
      descricao:
          'Cancelamento ativo de ruído e bateria de até 30h.',
      preco: 350.00,
    ),
  ];

  Future<void> _abrirDetalhes(
    BuildContext context,
    Produto produto,
  ) async {
    final resultado = await Navigator.pushNamed(
      context,
      '/detalhes',
      arguments: produto,
    );

    if (resultado != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Retorno da tela: $resultado',
          ),
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }

  Future<void> _abrirCadastro() async {
    final produto = await Navigator.pushNamed(
      context,
      '/cadastro',
    );

    if (produto is Produto && mounted) {
      setState(() {
        _produtos.add(produto);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${produto.nome} cadastrado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catálogo de Produtos',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _abrirCadastro,
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar produto',
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (ctx, index) {
          final prod = _produtos[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.indigoAccent,
                child: Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
              ),

              title: Text(
                prod.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                'R\$ ${prod.preco.toStringAsFixed(2)}',
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),

              onTap: () {
                _abrirDetalhes(
                  context,
                  prod,
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastro,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}