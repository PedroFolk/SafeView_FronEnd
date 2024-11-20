import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000"; // URL base da API

  Future<List<Map<String, dynamic>>> getUser(String email) async {
    final url = Uri.parse('$baseUrl/usuario/$email');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Conversão para lista de mapas
        final List<dynamic> data = json.decode(response.body)['usuarios'];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'Erro ao buscar usuários: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      // Tratamento de exceção
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<Map<String, dynamic>> validarCodigoRecuperacao(
      String email, String codigo, String senha) async {
    final url = Uri.parse('$baseUrl/validar_codigo_recuperacao');

    final Map<String, dynamic> requestBody = {
      'email': email,
      'codigo': codigo,
      'nova_senha': senha,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Registro bem-sucedido
        return json.decode(response.body);
      } else {
        // Algo deu errado, trate o erro aqui
        return {
          'error': true,
          'message': json.decode(response.body)['detail'] ?? 'Erro desconhecido'
        };
      }
    } catch (e) {
      // Exceção ao fazer a requisição
      return {'error': true, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> enviarCodigoRecuperacao(
      final String email) async {
    final url = Uri.parse('$baseUrl/enviar_codigo_recuperacao');

    final Map<String, dynamic> requestBody = {
      'email': email,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Registro bem-sucedido
        return json.decode(response.body);
      } else {
        // Algo deu errado, trate o erro aqui
        return {
          'error': true,
          'message': json.decode(response.body)['detail'] ?? 'Erro desconhecido'
        };
      }
    } catch (e) {
      // Exceção ao fazer a requisição
      return {'error': true, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteUser(
      String emailUsuarioApagando, String emailUsuarioAApagar) async {
    final url = Uri.parse(
        '$baseUrl/apagar_usuario/$emailUsuarioApagando/$emailUsuarioAApagar');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'error': true,
          'message': json.decode(response.body)['detail'] ?? 'Erro desconhecido'
        };
      }
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final url = Uri.parse('$baseUrl/usuarios');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Conversão para lista de mapas
        final List<dynamic> data = json.decode(response.body)['usuarios'];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'Erro ao buscar usuários: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      // Tratamento de exceção
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<Map<String, dynamic>> loginUser(
      final String email, String senha) async {
    final url = Uri.parse('$baseUrl/login');

    final Map<String, dynamic> requestBody = {
      'email': email,
      'senha': senha,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Registro bem-sucedido
        return json.decode(response.body);
      } else {
        // Algo deu errado, trate o erro aqui
        return {
          'error': true,
          'message': json.decode(response.body)['detail'] ?? 'Erro desconhecido'
        };
      }
    } catch (e) {
      // Exceção ao fazer a requisição
      return {'error': true, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> registerUser(
      String email, String nome, String senha) async {
    final url = Uri.parse(
        '$baseUrl/registra_usuario_padrao'); // Apenas o endpoint necessário

    // Montando o body da requisição
    final Map<String, dynamic> requestBody = {
      'email': email,
      'nome': nome,
      'senha': senha,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        // Registro bem-sucedido
        return json.decode(response.body);
      } else {
        // Algo deu errado, trate o erro aqui
        return {
          'error': true,
          'message': json.decode(response.body)['detail'] ?? 'Erro desconhecido'
        };
      }
    } catch (e) {
      // Exceção ao fazer a requisição
      return {'error': true, 'message': e.toString()};
    }
  }
}
