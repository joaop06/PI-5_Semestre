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

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login'); 
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('accessToken')) {
          print('Token recebido: ${data['accessToken']}');
          return data; // Retorna o mapa completo com os dados
        } else {
          print('Resposta inesperada: $data');
          return {'error': 'Token não encontrado'}; // Retorna erro
        }
      } else {
        print('Erro no login: ${response.statusCode}, ${response.body}');
return {
  'error': 'Erro no login',
  'message': jsonDecode(response.body)['message'] ?? 'Erro desconhecido',
};
      }
    } catch (e) {
  if (e is http.ClientException) {
    print('Erro de cliente: $e');
  } else {
    print('Erro inesperado: $e');
  }
  return {'error': 'Erro de conexão'};
}


}
}