// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/api_requests.dart';
import 'package:flutter_application_1/Components/custom_button.dart';
import 'package:flutter_application_1/Components/textfield_custom.dart';
import 'package:flutter_application_1/Pages/esqueceu_senha_page.dart';
import 'package:flutter_application_1/Pages/menu_page.dart';
import 'package:flutter_application_1/Pages/register_page.dart';
import 'package:flutter_application_1/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  Future<void> _login() async {
    String email = emailController.text.trim();
    String senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, preencha todos os campos.'),
      ));
      return;
    }

    final ApiService apiService = ApiService();
    final result = await apiService.loginUser(email, senha);

    if (result['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['message']),
      ));
    } else {
      Provider.of<UserProvider>(context, listen: false).setUser(email);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/trabalhadores_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Conteúdo acima da imagem
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      color: const Color.fromARGB(61, 0, 0, 0),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "SafeView",
                        style: GoogleFonts.juliusSansOne(
                          fontSize: 64,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
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
                              "Login",
                              style: GoogleFonts.jost(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        wdt: 375,
                        text1: 'email',
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        wdt: 375,
                        text1: 'Senha',
                        controller: senhaController,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        function: () {
                          _login();
                        },
                        text: 'LOGAR',
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EsqueceuSenhaPage()),
                            );
                          },
                          child: Text(
                            "Esqueceu a senha?",
                            style: GoogleFonts.jost(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(81, 93, 95, 0.8),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
