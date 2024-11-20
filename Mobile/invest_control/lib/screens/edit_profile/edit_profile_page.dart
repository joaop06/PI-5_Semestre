import 'package:flutter/material.dart';
import 'package:invest_control/services/api_service.dart';
import 'package:invest_control/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  String? _responseMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        setState(() {
          _responseMessage = 'Erro: Token não encontrado. Faça login novamente.';
        });
        return;
      }

      final userData = await _apiService.getUserData(token); // Requisição GET /users
      if (userData.containsKey('error')) {
        setState(() {
          _responseMessage = 'Erro ao carregar dados do usuário: ${userData['error']}';
        });
      } else {
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _emailController.text = userData['email'] ?? '';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Erro ao carregar dados: $e';
      });
    }
  }

  Future<void> _updateUserData() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        setState(() {
          _responseMessage = 'Erro: Token não encontrado. Faça login novamente.';
        });
        return;
      }

      final updatedData = {
        "name": _nameController.text,
        "email": _emailController.text,
      };

      final response = await _apiService.patchUserData(updatedData, token); // Requisição PATCH /users
      setState(() {
        _responseMessage = response.containsKey('error')
            ? 'Erro ao atualizar dados: ${response['error']}'
            : 'Dados atualizados com sucesso!';
      });
    } catch (e) {
      setState(() {
        _responseMessage = 'Erro ao enviar dados: $e';
      });
    }
  }

  void _navigateToChangePassword() {
    Navigator.pushNamed(context, '/change-password'); // Rota para a tela de alteração de senha
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateUserData,
              child: const Text('Salvar Alterações'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _navigateToChangePassword,
              child: const Text('Alterar Senha'),
            ),
            const SizedBox(height: 16),
            if (_responseMessage != null)
              Text(
                _responseMessage!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
