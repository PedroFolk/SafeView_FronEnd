import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/custom_button.dart';
import 'package:flutter_application_1/Components/textfield_custom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/Components/api_requests.dart';

class EsqueceuSenhaPage extends StatefulWidget {
  const EsqueceuSenhaPage({super.key});

  @override
  State<EsqueceuSenhaPage> createState() => _EsqueceuSenhaPageState();
}

class _EsqueceuSenhaPageState extends State<EsqueceuSenhaPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController codigoController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool isCodigoVisible = false;
  String buttonText = "Enviar Codigo";

  Future<void> _recuperarSenhaCodigo() async {
    String email = emailController.text.trim();
    final ApiService apiService = ApiService();
    final result = await apiService.enviarCodigoRecuperacao(email);

    if (result['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['message']),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Codigo de recuperação enviado ao email enviado"),
      ));
      setState(() {
        isCodigoVisible = true;
        buttonText = "Alterar Senha";
      });
    }
  }

  Future<void> _alterarSenha() async {
    String email = emailController.text.trim();
    String codigo = codigoController.text.trim();
    String senha = senhaController.text.trim();
    print(email);
    print(codigo);
    print(senha);
    final ApiService apiService = ApiService();
    final result =
        await apiService.validarCodigoRecuperacao(email, codigo, senha);

    if (result['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['message']),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Senha alterada com sucesso"),
      ));
      setState(() {
        isCodigoVisible = false;
        buttonText = "Enviar Codigo";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  "Recuperar Senha",
                  style: GoogleFonts.jost(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          CustomTextField(
            wdt: 375,
            text1: 'EMAIL',
            controller: emailController,
          ),
          if (isCodigoVisible) // Exibe o campo condicionalmente
            CustomTextField(
              wdt: 375,
              text1: 'Codigo de recuperação',
              controller: codigoController,
            ),
          if (isCodigoVisible) // Exibe o campo condicionalmente
            CustomTextField(
              wdt: 375,
              text1: 'Nova Senha',
              controller: senhaController,
              obscureText: true,
            ),
          const SizedBox(
            height: 50,
          ),
          CustomButton(
            function: () {
              if (isCodigoVisible) {
                _alterarSenha();
              } else {
                _recuperarSenhaCodigo();
              }
            },
            text: buttonText,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
