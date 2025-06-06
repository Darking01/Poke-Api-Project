import 'package:flutter/material.dart' hide Theme;
import 'package:provider/provider.dart';
import '../Widgets/resources.dart';
import '../Models/inicio_controller.dart';
import '../Visuales/theme.dart';

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
    final inicioController = Provider.of<InicioController>(context);

    return Scaffold(
      key: _scaffold,
      endDrawer: Drawer(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/imgs/home/backmenu.jpeg'),
                ),
              ),
            ),
            Container(color: const Color.fromARGB(185, 0, 0, 0)),
            Column(
              children: [
                const SizedBox(height: 60),
                const CircleAvatar(
                  backgroundColor: Theme.gris1,
                  backgroundImage: AssetImage('assets/imgs/home/pokeball.png'),
                  radius: 60,
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: inicioController.nombreEntrenador,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? Text(snapshot.data, style: Theme.lblTitle)
                        : const Text('Consultando...', style: Theme.lblTitle);
                  },
                ),

                const SizedBox(height: 20),
                const Divider(height: 1, color: Theme.gris3),
                //opciones
                optionMenuWidget(context, 'Pokemones', inicioController),
                optionMenuWidget(context, 'Equipos', inicioController),
                Expanded(child: Container()),
                optionSalirWidget(context, inicioController),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          inicioController.vistaSeleccionada == 'Pokemones'
              ? const Favoritos()
              : const Perfil(),
          SafeArea(
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                IconButton(
                  onPressed: () {
                    _scaffold.currentState!.openEndDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row optionSalirWidget(
    BuildContext context,
    InicioController inicioController,
  ) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        SizedBox(
          height: 80,
          child: InkWell(
            onTap: () => inicioController.clickSalir(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(width: 30, height: 20),
                Image(
                  height: 30,
                  image: AssetImage('assets/imgs/icon_logout.png'),
                ),
                SizedBox(width: 30, height: 49),
                Text('Salir', style: Theme.lblHomeOption),
              ],
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  InkWell optionMenuWidget(
    BuildContext context,
    String opcion,
    InicioController inicioController,
  ) {
    return InkWell(
      onTap: () {
        inicioController.clickOpcion(context, opcion);
      },
      child: SizedBox(
        height: 50,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 30),
                  const Image(
                    height: 30,
                    image: AssetImage('assets/imgs/pokeball_gray.png'),
                  ),
                  const SizedBox(width: 30, height: 49),
                  Text(opcion, style: Theme.lblHomeOption),
                ],
              ),
            ),
            const Divider(height: 1, color: Theme.gris3),
          ],
        ),
      ),
    );
  }
}

class Perfil extends StatelessWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Perfil'));
  }
}

class Favoritos extends StatelessWidget {
  const Favoritos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Favoritos'));
  }
}
