import '../pantallas/login.dart';
import 'package:flutter/material.dart';

class InicioController with ChangeNotifier {
  // VARIABLES:
  String _vistaSeleccionada = 'Pokemones';
  String _nombreEntrenador = '';

  // GETTERS:
  String get vistaSeleccionada => _vistaSeleccionada;
  Future<String> get nombreEntrenador async {
    var DB;
    final entrenador = await DB.obtenerEntrenador();
    _nombreEntrenador = entrenador.nombre.toString();
    return _nombreEntrenador;
  }

  void clickOpcion(BuildContext context, String vista) {
    Navigator.pop(context);
    if (_vistaSeleccionada == 'Pokemones' && vista == 'Equipos') {
      _vistaSeleccionada = "Equipos";
    }
    if (_vistaSeleccionada == 'Equipos' && vista == 'Pokemones') {
      _vistaSeleccionada = "Pokemones";
      /*     final listacontroller = Provider.of<ListaController>(
        context,
        listen: false,
      );
      listacontroller.resetGrupo();
    }
    infoprint(_vistaSeleccionada);
    notifyListeners();
  }*/

      /*Future<void> clickSalir(BuildContext context) async {
    /*final listacontroller = Provider.of<ListaController>(
      context,
      listen: false,
    );
    await DB.desactivaEntrenador(_nombreEntrenador);
    listacontroller.resetGrupo();*/
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const LoginScreen(),
        transitionDuration: Duration.zero,
      ),
    );*/
      _vistaSeleccionada = 'Pokemones';
    }
  }

  void clickSalir(BuildContext context) {}
}
