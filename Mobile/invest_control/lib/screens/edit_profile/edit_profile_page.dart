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
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos antes de salvar.');
      return;
    }

    final email = _emailController.text.trim();
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(email)) {
      _showSnackBar('Por favor, insira um e-mail válido.');
      return;
    }

    final userId = await _authService.getUserId();
    final token = await _authService.getAccessToken();

    if (userId == null || token == null) {
      _showSnackBar(
          'Erro: Usuário ou token não encontrado. Faça login novamente.');
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
        _showSnackBar('Erro ao atualizar perfil.');
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
        _showSnackBar(
            'Erro: Usuário ou token não encontrado. Faça login novamente.');
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF23242B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(icon, color: Colors.white54),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        title: Text(
          'Editar Perfil',
          style: TextStyle(
            color: Colors.amber[400],
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber[400]?.withOpacity(0.1),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: Colors.amber[400],
                        ),
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Nome', Icons.person),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('E-mail', Icons.email),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _navigateToChangePassword,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.amber[400]!),
                          foregroundColor: Colors.amber[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Alterar Senha',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateUserData,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.amber[400],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Salvar Alterações',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
