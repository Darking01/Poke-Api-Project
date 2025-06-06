import 'package:app_data/pantallas/account_options.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  InicioState createState() => InicioState();
}

class InicioState extends State<Inicio> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.blue,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo de Flutter"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Inicio"),
            Tab(icon: Icon(Icons.favorite), text: "Favoritos"),
            Tab(icon: Icon(Icons.settings), text: "Ajustes"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              _showSnackBar(context, 'Notificaciones han sido presionadas');
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Primer tab - Inicio mostrando pokémones en tarjetas cuadradas
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchPokemons(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No se encontraron pokémones.'),
                );
              }
              final pokemons = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columnas
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1, // cuadrado
                ),
                itemCount: pokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = pokemons[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: Text(
                                pokemon['name'].toString().toUpperCase(),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (pokemon['image'] != null)
                                    Image.network(
                                      pokemon['image'],
                                      width: 240,
                                      height: 240,
                                      fit: BoxFit.contain,
                                    ),
                                  const SizedBox(height: 16),
                                  Text('¡Haz atrapado a ${pokemon['name']}!'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            ),
                      );
                    },
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (pokemon['image'] != null)
                              Image.network(
                                pokemon['image'],
                                width: 330,
                                height: 300,
                                fit: BoxFit.contain,
                              ),
                            const SizedBox(height: 12),
                            Text(
                              pokemon['name'].toString().toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Segundo tab - Favoritos (puedes personalizarlo)
          const Center(child: Text('Favoritos')),

          // Tercer tab - Ajustes
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Pantalla de Ajustes',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showSnackBar(
                      context,
                      'Ajustes guardados',
                      backgroundColor: Colors.green,
                    );
                  },
                  child: const Text('Guardar ajustes'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountOptionsScreen(),
                      ),
                    );
                  },
                  child: const Text('Opciones de cuenta'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSnackBar(
            context,
            'Floating ha sido presionado en la tab: ${_tabController.index + 1}',
          );
        },
        child: const Icon(Icons.add),
        tooltip: "Agregar",
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu Drawer',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Inicio"),
              onTap: () {
                _tabController.animateTo(0);
                Navigator.pop(context);
                Tab(icon: Icon(Icons.home), text: "Inicio");
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favoritos"),
              onTap: () {
                _tabController.animateTo(1);
                Navigator.pop(context);
                Tab(icon: Icon(Icons.favorite), text: "Inicio");
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Ajustes"),
              onTap: () {
                _tabController.animateTo(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// metodo para conseguir los pokes
Future<List<Map<String, dynamic>>> fetchPokemons() async {
  final response = await http.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List results = data['results'];
    // info de cada pokemon
    List<Map<String, dynamic>> pokemons = [];
    for (var item in results) {
      final detailResponse = await http.get(Uri.parse(item['url']));
      if (detailResponse.statusCode == 200) {
        final detailData = json.decode(detailResponse.body);
        final id = detailData['id'];
        final imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
        pokemons.add({'name': detailData['name'], 'image': imageUrl});
      }
    }
    return pokemons;
  } else {
    throw Exception('Error al cargar los pokémones');
  }
}
