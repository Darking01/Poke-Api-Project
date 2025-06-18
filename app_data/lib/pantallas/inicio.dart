import 'package:app_data/pantallas/account_options.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//INICIO
class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  InicioState createState() => InicioState();
}

class InicioState extends State<Inicio> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  Set<String> _favoritos = {};
  List<Map<String, dynamic>>? _pokemonsCache;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });

    fetchPokemons().then((lista) {
      setState(() {
        _pokemonsCache = lista;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.blue}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritosList = _pokemonsCache
        ?.where((poke) => _favoritos.contains(poke['name']))
        .toList();

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
            onPressed: () =>
                _showSnackBar(context, 'Notificaciones presionadas'),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _pokemonsCache == null
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: _pokemonsCache!.length,
                  itemBuilder: (context, index) {
                    final pokemon = _pokemonsCache![index];
                    final isFavorito = _favoritos.contains(pokemon['name']);

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title:
                                Text(pokemon['name'].toString().toUpperCase()),
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
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (pokemon['image'] != null)
                                    Image.network(
                                      pokemon['image'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  const SizedBox(height: 12),
                                  Text(
                                    pokemon['name']
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color:
                                      isFavorito ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (isFavorito) {
                                      _favoritos.remove(pokemon['name']);
                                    } else {
                                      _favoritos.add(pokemon['name']);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

          // Tab Favoritos
          (favoritosList == null || favoritosList.isEmpty)
              ? const Center(child: Text('No tienes favoritos aún.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: favoritosList.length,
                  itemBuilder: (context, index) {
                    final pokemon = favoritosList[index];
                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (pokemon['image'] != null)
                            Image.network(
                              pokemon['image'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          const SizedBox(height: 12),
                          Text(
                            pokemon['name'].toString().toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),

          // Tab Ajustes
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
        onPressed: () =>
            _showSnackBar(context, 'Floating presionado en la Tab $_currentIndex'),
        child: const Icon(Icons.add),
        tooltip: "Agregar",
      ),
    );
  }
}

// Lógica para obtener pokémones
Future<List<Map<String, dynamic>>> fetchPokemons() async {
  final response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List results = data['results'];

    final pokemons = await Future.wait(results.map((item) async {
      final detailResponse = await http.get(Uri.parse(item['url']));
      if (detailResponse.statusCode == 200) {
        final detailData = json.decode(detailResponse.body);
        final id = detailData['id'];
        final imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
        return {'name': detailData['name'], 'image': imageUrl};
      }
      return {'name': item['name'], 'image': null};
    }));

    return pokemons;
  } else {
    throw Exception('Error al cargar los pokémones');
  }
}
