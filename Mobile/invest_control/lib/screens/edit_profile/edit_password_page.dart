import 'package:flutter/material.dart';
import 'package:invest_control/services/auth_service.dart';
import 'package:invest_control/services/api_service.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _authService = AuthService();
  bool _isLoading = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userId = await _authService.getUserId();
    final token = await _authService.getAccessToken();

    if (userId == null || token == null) {
      _showSnackBar('Erro: Usuário ou token não encontrado. Faça login novamente.');
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    final requestBody = {
      "userId": userId.toString(),
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };

    try {
      _showSnackBar('Enviando solicitação...');
      final response = await _apiService.postRequest(
        'http://localhost:3000/change-password',
        requestBody,
        token,
      );

      if (response.containsKey('success') && response['success'] == true) {
        _showSnackBar('Senha alterada com sucesso!');
        Navigator.pop(context);
      } else {
        _showSnackBar('Erro ao alterar senha: ${response['error'] ?? 'desconhecido.'}');
      }
    } catch (e) {
      _showSnackBar('Erro ao tentar alterar senha: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha Atual'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira a senha atual.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Nova Senha'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira a nova senha.';
                  }
                  if (value.trim().length < 6) {
                    return 'A nova senha deve ter pelo menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _changePassword,
                      child: Text('Salvar Alterações'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
