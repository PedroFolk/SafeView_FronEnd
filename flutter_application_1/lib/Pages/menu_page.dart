import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/web_cam_streaming.dart';
import 'package:flutter_application_1/Pages/gerencia_usuarios.dart';
import 'package:flutter_application_1/Pages/login_page.dart';
import 'package:flutter_application_1/Pages/main_page.dart';
import 'package:flutter_application_1/Pages/menu_selector_page.dart';
import 'package:flutter_application_1/Pages/register_page.dart';
import 'package:flutter_application_1/Pages/relatorio_page.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      MenuSelectorPage(onButtonPressed: _onItemTapped),
      const RegisterPage(),
      const WebcamStreamScreen(),
      const StorageListPage(),
      const GerenciaUsuarios(),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 32),
        backgroundColor: const Color.fromRGBO(72, 105, 110, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "SafeView",
              style: GoogleFonts.juliusSansOne(
                fontSize: 48,
                color: Colors.white,
              ),
            ),
            IconButton(
                onPressed: () {
                  Provider.of<UserProvider>(context, listen: false).setUser("email", "senha");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.person,
        //       size: 48,
        //       color: Colors.white,
        //     ),
        //   )
        // ],
      ),
      body: widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(72, 105, 110, 1),
              ),
              child: Center(
                child: Text(
                  "SafeView",
                  style: GoogleFonts.juliusSansOne(
                    fontSize: 56,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Menu'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Visualizar Camera'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Registrar'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Documentos'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
