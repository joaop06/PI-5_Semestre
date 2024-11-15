import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.100.49:3000'; // Altere para o URL real do back-end

  Future<bool> registerUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users'); // Substitua pela rota correta no NestJS

    try {
      // Log dos dados enviados
      print('Enviando dados para cadastro:');
      print('Name: $name');
      print('Email: $email');
      print('Password: $password');
      print('url: $url');

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
}
