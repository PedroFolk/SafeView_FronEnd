import 'package:flutter/material.dart';

class MenuSelectorPage extends StatefulWidget {
  final Function(int) onButtonPressed;

  const MenuSelectorPage({super.key, required this.onButtonPressed});

  @override
  State<MenuSelectorPage> createState() => _MenuSelectorPageState();
}

class _MenuSelectorPageState extends State<MenuSelectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Button(
                legenda: "Câmera",
                function: () {
                  widget.onButtonPressed(2);
                },
                icon: const Icon(
                  Icons.videocam_outlined,
                  size: 128,
                ),
              ),
              Button(
                legenda: "Gerenciar Usuarios",
                function: () {
                  widget.onButtonPressed(4);
                },
                icon: const Icon(
                  Icons.badge_outlined,
                  size: 128,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Button(
                legenda: "Registrar usuários",
                function: () {
                  widget.onButtonPressed(1);
                },
                icon: const Icon(
                  Icons.people_outline,
                  size: 128,
                ),
              ),
              Button(
                legenda: "Relatório",
                function: () {
                  widget.onButtonPressed(3);
                },
                icon: const Icon(
                  Icons.document_scanner_outlined,
                  size: 128,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback function;
  final Icon icon;
  final String legenda;

  const Button({
    super.key,
    required this.function,
    required this.icon,
    required this.legenda,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: function, // Sem parênteses, para ser executada apenas ao clicar
        child: Column(
          children: [
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: icon,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              legenda,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
