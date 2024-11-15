import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:invest_control/services/api_service.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

  class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

void _login() async {
  final email = _emailController.text;
  final password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    _showMessage('Preencha todos os campos');
    return;
  }

  final response = await _apiService.login(email, password);

  print('Resposta da API: $response');

  if (response.containsKey('error')) {
    final errorString = response['error'];

    try {
      // Extrai o JSON aninhado de dentro da string
      final jsonStartIndex = errorString.indexOf('{');
      final jsonEndIndex = errorString.lastIndexOf('}');
      if (jsonStartIndex != -1 && jsonEndIndex != -1) {
        final jsonSubstring = errorString.substring(jsonStartIndex, jsonEndIndex + 1);
        final nestedJson = jsonDecode(jsonSubstring);

        if (nestedJson.containsKey('accessToken')) {
          final token = nestedJson['accessToken'];
          _showMessage('Login realizado com sucesso!');
          print('Token recebido: $token');
          Navigator.pushNamed(context, '/home');
          return;
        }
      }
    } catch (e) {
      print('Erro ao processar o JSON aninhado: $e');
    }

    _showMessage('Erro no login: ${response['error']}');
  } else {
    _showMessage('Erro inesperado na resposta da API.');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Cadastrar Novo Usuário'),
              ),
          ],
        ),
      ),
    );
  }
}

class ApiService {
  final String baseUrl = 'http://localhost:3000';

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
      return data; // Retorna o mapa com os dados
    } else {
      return {'error': 'Erro no login: ${response.body}'};
    }
  } catch (e) {
    return {'error': 'Erro ao conectar com o servidor: $e'};
  }
}

}
