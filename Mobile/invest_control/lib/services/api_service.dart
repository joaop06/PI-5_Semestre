import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000'; // Altere para o URL real do back-end
  //final String baseUrl = 'https://pi5.semestre.fluxocar.com.br'; // Altere para o URL real do back-end

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

  Future<Map<String, dynamic>> postCryptoRisk(Map<String, dynamic> data, String token) async {
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
          'error': 'Erro ao buscar dados do usuário: ${response.statusCode}, ${response.body}'
        };
      }
    } catch (e) {
      return {'error': 'Erro ao conectar ao servidor: $e'};
    }
  }

  // Método para atualizar os dados do usuário (PATCH /users)
  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> data, String token) async {
  final url = Uri.parse('$baseUrl/users/$userId');
  try {
    final response = await http.patch(
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



  // Método para alterar a senha do usuário (POST /users/change-password)
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
          'error': 'Erro ao alterar senha: ${response.statusCode}, ${response.body}'
        };
      }
    } catch (e) {
      return {'error': 'Erro ao conectar ao servidor: $e'};
    }
  }
}