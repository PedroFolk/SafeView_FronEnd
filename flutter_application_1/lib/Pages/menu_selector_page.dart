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
                function: () {
                  widget.onButtonPressed(2);
                },
                icon: const Icon(
                  Icons.videocam_outlined,
                  size: 128,
                ),
              ),
              Button(
                function: () {
                  widget.onButtonPressed(0);
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
                function: () {
                  widget.onButtonPressed(1);
                },
                icon: const Icon(
                  Icons.people_outline,
                  size: 128,
                ),
              ),
              Button(
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

  const Button({
    super.key,
    required this.function,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: function, // Sem parênteses, para ser executada apenas ao clicar
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            boxShadow: [
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
      ),
    );
  }
}
