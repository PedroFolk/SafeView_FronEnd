// ignore_for_file: use_build_context_synchronously

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
  TextEditingController senhaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();

  Future<void> _register() async {
    String email = emailController.text.trim(); // Removendo espaços
    String nome = nomeController.text.trim();
    String senha = senhaController.text;
    String confirmarSenha = confirmarSenhaController.text;

    // Verificação se os campos estão vazios
    if (email.isEmpty ||
        nome.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, preencha todos os campos.'),
      ));
      return;
    }

    // Verificação de correspondência de senha
    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('As senhas não coincidem.'),
      ));
      return;
    }

    final ApiService apiService = ApiService();

    final result = await apiService.registerUser(email, nome, senha);

    if (result['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['message']),
      ));
    } else {
      // Registro bem-sucedido, navega para a MainPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Row(
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
                  const SizedBox(
                    height: 40,
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
                        controller: nomeController,
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
                  CustomTextField(
                    wdt: 375,
                    text1: 'SENHA',
                    controller: senhaController,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    wdt: 375,
                    text1: 'CONFIRMAR SENHA',
                    controller: confirmarSenhaController,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    function: () {
                      _register();
                    },
                    text: 'Registrar',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
