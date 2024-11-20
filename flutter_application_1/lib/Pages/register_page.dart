// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/custom_button.dart';
import 'package:flutter_application_1/Components/api_requests.dart';
import 'package:flutter_application_1/Components/textfield_custom.dart';
import 'package:flutter_application_1/Pages/main_page.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sobreNomeController = TextEditingController();

  Future<void> _register() async {
    String email = emailController.text.trim(); // Removendo espaços
    String nome = nomeController.text.trim();
    var senhaSecreta = Random.secure();
    String senha = List.generate(10, (_) => senhaSecreta.nextInt(26) + 97)
        .map((e) => String.fromCharCode(e))
        .join();

    String sobrenome = sobreNomeController.text;
    String nomeCompleto = "$nome $sobrenome";

    // Verificação se os campos estão vazios
    if (email.isEmpty || nome.isEmpty || senha.isEmpty || sobrenome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, preencha todos os campos.'),
      ));
      return;
    }

    final ApiService apiService = ApiService();

    final result = await apiService.registerUser(email, nomeCompleto, senha);

    if (result['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['message']),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Usuario registrado com sucesso"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 16,
                ),
                child: Text(
                  "Register",
                  style: GoogleFonts.jost(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        wdt: 185,
                        text1: 'NOME',
                        controller: nomeController,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomTextField(
                        wdt: 185,
                        text1: 'SOBRENOME',
                        controller: sobreNomeController,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    wdt: 375,
                    text1: 'EMAIL',
                    controller: emailController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                function: () {
                  _register();
                },
                text: 'Registrar',
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
