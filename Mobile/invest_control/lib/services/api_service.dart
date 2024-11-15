import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000'; // Altere para o URL real do back-end

  Future<bool> registerUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users'); // Substitua pela rota correta no NestJS

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
      return true; // Sucesso
    } else {
      print('Erro: ${response.body}');
      return false; // Falha
    }
  }
}
