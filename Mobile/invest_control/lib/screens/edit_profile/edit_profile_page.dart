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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  Future<void> _updateUserData() async {
  if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
    _showSnackBar('Por favor, preencha todos os campos antes de salvar.');
    return; 
  }

  final email = _emailController.text.trim();
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  if (!emailRegex.hasMatch(email)) {
    _showSnackBar('Por favor, insira um e-mail válido.');
    return; 
  }

  final userId = await _authService.getUserId();
  final token = await _authService.getAccessToken();

  if (userId == null || token == null) {
    _showSnackBar('Erro: Usuário ou token não encontrado. Faça login novamente.');
    Navigator.pushReplacementNamed(context, '/login');
    return; 
  }

  final updatedData = {
    "name": _nameController.text.trim(),
    "email": email,
  };

  try {
    final response = await _apiService.updateUser(userId, updatedData, token);

    if (response.containsKey('success') && response['success'] == true) {
      _showSnackBar('Atualização realizada com sucesso!');
    } else {
      _showSnackBar('Atualização realizada com sucesso!');
    }
  } catch (e) {
    _showSnackBar('Erro ao tentar atualizar: $e');
  }
}



Future<void> _loadUserData() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final userId = await _authService.getUserId();
    final token = await _authService.getAccessToken();

    if (userId == null || token == null) {
      _showSnackBar('Erro: Usuário ou token não encontrado. Faça login novamente.');
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final userData = await _apiService.getUserById(userId, token);
    if (userData.containsKey('error')) {
      _showSnackBar('Erro ao carregar dados: ${userData['error']}');
    } else {
      _nameController.text = userData['name'] ?? '';
      _emailController.text = userData['email'] ?? '';
    }
  } catch (e) {
    _showSnackBar('Erro ao carregar dados: $e');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  void _navigateToChangePassword() {
    Navigator.pushNamed(context, '/change-password'); 
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _navigateToChangePassword,
                    child: const Text('Alterar Senha'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _updateUserData,
                    child: const Text('Salvar Alterações'),
                  ),
                  
                ],
              ),
            ),
    );
  }
}
