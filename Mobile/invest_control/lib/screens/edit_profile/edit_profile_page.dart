// import 'package:flutter/material.dart';
// import 'package:invest_control/services/api_service.dart';
// import 'package:invest_control/services/auth_service.dart';

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final ApiService _apiService = ApiService();
//   final AuthService _authService = AuthService();

//   String? _responseMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     try {
//       final token = await _authService.getAccessToken();
//       if (token == null) {
//         setState(() {
//           _responseMessage = 'Erro: Token não encontrado. Faça login novamente.';
//         });
//         return;
//       }

//       final userData = await _apiService.getUserData(token); // Requisição GET /users
//       if (userData.containsKey('error')) {
//         setState(() {
//           _responseMessage = 'Erro ao carregar dados do usuário: ${userData['error']}';
//         });
//       } else {
//         setState(() {
//           _nameController.text = userData['name'] ?? '';
//           _emailController.text = userData['email'] ?? '';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _responseMessage = 'Erro ao carregar dados: $e';
//       });
//     }
//   }

//   Future<void> _updateUserData() async {
//     try {
//       final token = await _authService.getAccessToken();
//       if (token == null) {
//         setState(() {
//           _responseMessage = 'Erro: Token não encontrado. Faça login novamente.';
//         });
//         return;
//       }

//       final updatedData = {
//         "name": _nameController.text,
//         "email": _emailController.text,
//       };

//       final response = await _apiService.patchUserData(updatedData, token); // Requisição PATCH /users
//       setState(() {
//         _responseMessage = response.containsKey('error')
//             ? 'Erro ao atualizar dados: ${response['error']}'
//             : 'Dados atualizados com sucesso!';
//       });
//     } catch (e) {
//       setState(() {
//         _responseMessage = 'Erro ao enviar dados: $e';
//       });
//     }
//   }

//   void _navigateToChangePassword() {
//     Navigator.pushNamed(context, '/change-password'); // Rota para a tela de alteração de senha
//   }

//   void showSnackBar(String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text(message)),
//   );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Editar Perfil'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Nome'),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'E-mail'),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _updateUserData,
//               child: const Text('Salvar Alterações'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _navigateToChangePassword,
//               child: const Text('Alterar Senha'),
//             ),
//             const SizedBox(height: 16),
//             if (_responseMessage != null)
//               Text(
//                 _responseMessage!,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


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

  bool _isLoading = false; // Controla o estado de carregamento

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        _showSnackBar('Erro: Token não encontrado. Faça login novamente.');
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final userData = await _apiService.getUserData(token); // Requisição GET /users
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

//   Future<void> _updateUserData() async {
//   if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
//     _showSnackBar('Por favor, preencha todos os campos.');
//     return;
//   }

//   if (!_emailController.text.contains('@')) {
//     _showSnackBar('Por favor, insira um email válido.');
//     return;
//   }

//   setState(() {
//     _isLoading = true;
//   });

//   try {
//     final token = await _authService.getAccessToken();
//     if (token == null) {
//       _showSnackBar('Erro: Token não encontrado. Faça login novamente.');
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     final updatedData = {
//       "name": _nameController.text.trim(),
//       "email": _emailController.text.trim(),
//     };

//     final response = await _apiService.updateUser(updatedData, token);
    
//     if (response['success'] == true) {
//       _showSnackBar('Dados atualizados com sucesso!');
//       Navigator.pop(context); // Volta para a tela anterior
//     } else if (response.containsKey('error')) {
//       _showSnackBar('Erro ao atualizar: ${response['error']}');
//     } else {
//       _showSnackBar('Erro desconhecido ao atualizar.');
//     }
//   } catch (e) {
//     _showSnackBar('Erro ao enviar dados: $e');
//   } finally {
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }

  Future<void> _updateUserData() async {
  final userId = await _authService.getUserId();
  final token = await _authService.getAccessToken();

  if (userId == null || token == null) {
    _showSnackBar('Erro: Usuário ou token não encontrado. Faça login novamente.');
    Navigator.pushReplacementNamed(context, '/login');
    return;
  }

  final updatedData = {
    "name": _nameController.text,
    "email": _emailController.text,
  };

  final response = await _apiService.updateUser(userId, updatedData, token);
  // Aqui, a função updateUser deve receber userId como parâmetro
}



  void _navigateToChangePassword() {
    Navigator.pushNamed(context, '/change-password'); // Rota para a tela de alteração de senha
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
