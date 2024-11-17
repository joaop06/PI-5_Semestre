import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000'; // Altere para o URL real do back-end

  Future<bool> registerUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users'); // Substitua pela rota correta no NestJS

    try {
      // Log dos dados enviados
      print('Enviando dados para cadastro:');
      print('Name: $name');
      print('Email: $email');
      print('Password: $password');
      print('url: $url');
      print('Tentando conectar ao servidor: $url');


      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Sucesso
        print('Usuário registrado com sucesso');
        return true;
      } else {
        // Erro: mostra o código de status e o corpo da resposta
        print('Erro: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      // Captura de erros de rede ou outros
      print('Erro ao conectar com o servidor: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Erro: ${response.statusCode}',
          'message': jsonDecode(response.body)['message'] ?? 'Erro desconhecido',
        };
      }
    } catch (e) {
      return {'error': 'Erro de conexão', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(
        url,
        headers: headers ?? {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Erro: ${response.statusCode}',
          'message': jsonDecode(response.body)['message'] ?? 'Erro desconhecido',
        };
      }
    } catch (e) {
      return {'error': 'Erro de conexão', 'message': e.toString()};
    }
  }

}