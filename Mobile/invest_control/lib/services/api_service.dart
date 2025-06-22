import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // final String baseUrl = 'http://localhost:3000';
  final String baseUrl = 'https://pi5.semestre.fluxocar.com.br';

  Future<bool> registerUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users');

    try {
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
        print('Usuário registrado com sucesso');
        return true;
      } else {
        print('Erro: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao conectar com o servidor: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
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
          'message':
              jsonDecode(response.body)['message'] ?? 'Erro desconhecido',
        };
      }
    } catch (e) {
      return {'error': 'Erro de conexão', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
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
          'message':
              jsonDecode(response.body)['message'] ?? 'Erro desconhecido',
        };
      }
    } catch (e) {
      return {'error': 'Erro de conexão', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> postCryptoRisk(
      Map<String, dynamic> data, String token) async {
    final url = Uri.parse('$baseUrl/crypto-risk');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Erro: ${response.statusCode}, ${response.body}'};
      }
    } catch (e) {
      return {'error': 'Erro ao conectar com o servidor: $e'};
    }
  }

  Future<Map<String, dynamic>> getUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error':
              'Erro ao buscar dados do usuário: ${response.statusCode}, ${response.body}'
        };
      }
    } catch (e) {
      return {'error': 'Erro ao conectar ao servidor: $e'};
    }
  }

  Future<Map<String, dynamic>> changePassword(
      Map<String, dynamic> data, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error':
              'Erro ao alterar senha: ${response.statusCode}, ${response.body}'
        };
      }
    } catch (e) {
      return {'error': 'Erro ao conectar ao servidor: $e'};
    }
  }

  Future<Map<String, dynamic>> getUserById(String userId, String token) async {
    final url = Uri.parse('$baseUrl/users/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Erro ao buscar dados do usuário: ${response.body}'};
      }
    } catch (e) {
      return {'error': 'Erro de conexão: $e'};
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String userId, Map<String, String> updatedData, String token) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    print("Enviando requisição para $url via PATCH");
    print("Headers: $headers");
    print("Body: $updatedData");

    final response = await http.patch(
      url,
      headers: headers,
      body: jsonEncode(updatedData),
    );

    print("Resposta da API: ${response.statusCode}");
    print("Corpo da resposta: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'success': false, 'error': response.body};
    }
  }

  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> body, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password/${body["userId"]}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro na solicitação: ${response.body}');
    }
  }
}
