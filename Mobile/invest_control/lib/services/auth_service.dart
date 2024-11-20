import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http; 
import 'api_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class AuthService {
  final ApiService _apiService = ApiService();  // Usando o ApiService para chamadas de API
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final String baseUrl = 'http://localhost:3000';  // Defina a URL base para a API

  Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Resposta da API: $data');

      if (data.containsKey('accessToken') && data['accessToken'].isNotEmpty) {
        print('Token recebido: ${data['accessToken']}');
        await _storage.write(key: 'accessToken', value: data['accessToken']);
        return {'success': true, 'message': 'Login realizado com sucesso!'};
      } else {
        print('Erro: Token ausente ou vazio');
        return {'success': false, 'message': 'Token não encontrado. Verifique suas credenciais.'};
      }
    } else {
      final errorMsg = jsonDecode(response.body)['message'] ?? 'Erro desconhecido';
      print('Erro no login: $errorMsg');
      return {'success': false, 'message': 'Login falhou: $errorMsg'};
    }
  } catch (e) {
    print('Erro ao fazer login: $e');
    return {'success': false, 'message': 'Erro ao conectar com o servidor. Tente novamente.'};
  }
}

  // Recuperar o token do armazenamento
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  // Validar o token
  Future<bool> validateToken() async {
    final token = await getAccessToken();
    if (token == null) return false;

    try {
      final response = await _apiService.get('/auth/validate', headers: {
        'Authorization': 'Bearer $token',
      });
      return response['valid'] == true;  // Ajuste baseado no que a API retorna
    } catch (e) {
      return false;
    }
  }

  // Logout (apagar o token)
  Future<void> logout() async {
    await _storage.delete(key: 'accessToken');
    print('Token removido com sucesso.');
  }

 Future<String?> getUserId() async {
  final token = await getAccessToken(); // Recupera o token armazenado
  if (token == null) {
    print("Token não encontrado."); // Log de erro para token ausente
    throw Exception("Token não encontrado");
  }

  final payload = JwtDecoder.decode(token); // Decodifica o token
  print("Payload decodificado: $payload"); // Log para ver o conteúdo do token decodificado

  final userId = payload['sub']; // A chave 'sub' deve conter o ID do usuário
  print("UserId extraído do payload: $userId"); // Log para verificar o valor do userId

  if (userId == null) {
    print("UserId não encontrado no payload."); // Log de erro para userId ausente
    throw Exception("UserId não encontrado no payload");
  }

  if (userId is! String) {
    print("UserId não é uma string, convertendo: $userId"); // Log se precisar de conversão
    return userId.toString();
  }

  return userId;
}



}
