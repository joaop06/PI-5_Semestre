import 'package:flutter/material.dart';
import 'package:invest_control/services/api_service.dart';
import 'package:invest_control/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _lowController = TextEditingController();
  final TextEditingController _highController = TextEditingController();
  final TextEditingController _openController = TextEditingController();
  final TextEditingController _closeController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();

  String? _responseResult;
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService(); // Instância do AuthService



  // void _sendCryptoData() async {
  //   // Cria o mapa com os dados inseridos pelo usuário
  //   final data = {
  //     "low": double.tryParse(_lowController.text) ?? 0.0,
  //     "high": double.tryParse(_highController.text) ?? 0.0,
  //     "open": double.tryParse(_openController.text) ?? 0.0,
  //     "close": double.tryParse(_closeController.text) ?? 0.0,
  //     "volume": int.tryParse(_volumeController.text) ?? 0,
  //   };

  //   // Valida os campos
  //   if (data.values.contains(0)) {
  //     setState(() {
  //       _responseResult = 'Por favor, preencha todos os campos corretamente.';
  //     });
  //     return;
  //   }

  //   try {
  //     // Recupera o token de acesso
  //     final token = await _authService.getAccessToken();
  //     print('Token recuperado: $token');
  //     if (token == null) {
  //       setState(() {
  //         _responseResult = 'Erro: Token de acesso não encontrado. Faça login novamente.';
  //       });
  //       return;
  //     }

  //     // Envia os dados para o back-end
  //     final response = await _apiService.postCryptoRisk(data, token);
  //     print('Resposta da API: $response');

  //     // Atualiza a tela com a resposta do servidor
  //     setState(() {
  //       _responseResult = response.containsKey('error')
  //           ? 'Erro: ${response['error']}'
  //           : 'Risco de Investimento: ${response['risk']}';
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _responseResult = 'Erro ao enviar dados: $e';
  //     });
  //   }
  // }

  bool _isSending = false; // Estado para controlar o botão

void _sendCryptoData() async {
  // Evita múltiplos envios simultâneos
  if (_isSending) return;

  setState(() {
    _isSending = true;
    _responseResult = ''; // Limpa mensagens anteriores
  });

  // Cria o mapa com os dados inseridos pelo usuário
  final data = {
    "low": double.tryParse(_lowController.text) ?? 0.0,
    "high": double.tryParse(_highController.text) ?? 0.0,
    "open": double.tryParse(_openController.text) ?? 0.0,
    "close": double.tryParse(_closeController.text) ?? 0.0,
    "volume": int.tryParse(_volumeController.text) ?? 0,
  };

  // Valida os campos
  if (data.values.contains(0)) {
    setState(() {
      _responseResult = 'Por favor, preencha todos os campos corretamente.';
      _isSending = false; // Libera o botão novamente
    });
    return;
  }

  try {
    // Recupera o token de acesso
    final token = await _authService.getAccessToken();
    print('Token recuperado: $token');
    if (token == null) {
      setState(() {
        _responseResult = 'Erro: Token de acesso não encontrado. Faça login novamente.';
        _isSending = false;
      });
      return;
    }

    // Envia os dados para o back-end
    final response = await _apiService.postCryptoRisk(data, token);
    print('Resposta da API: $response');

    // Atualiza a tela com a resposta do servidor
    setState(() {
      _responseResult = response.containsKey('error')
          ? 'Erro: ${response['error']}'
          : 'Risco de Investimento: ${response['risk']}';
      _isSending = false;
    });
  } catch (e) {
    setState(() {
      _responseResult = 'Erro ao enviar dados: $e';
      _isSending = false;
    });
  }
}


  void _logout() async {
  await _authService.logout(); // Limpa o token armazenado
  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Navega para a tela inicial
}

  void _editProfile() {
    Navigator.pushNamed(context, '/edit-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Criptomoedas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _editProfile,
            tooltip: 'Editar Usuário',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SingleChildScrollView(  // Envolvendo o corpo com SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _lowController,
                decoration: const InputDecoration(
                  labelText: 'Valor mais baixo (Low)',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _highController,
                decoration: const InputDecoration(
                  labelText: 'Valor mais alto (High)',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _openController,
                decoration: const InputDecoration(
                  labelText: 'Valor de abertura (Open)',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _closeController,
                decoration: const InputDecoration(
                  labelText: 'Valor de fechamento (Close)',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _volumeController,
                decoration: const InputDecoration(
                  labelText: 'Volume',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSending ? null : _sendCryptoData,
                child: _isSending 
                // ignore: prefer_const_constructors
                ? CircularProgressIndicator(color: Colors.white)
                // ignore: prefer_const_constructors
                : Text('Enviar Dados'),
              ),
              const SizedBox(height: 16),
              if (_responseResult != null)
                Text(
                  _responseResult!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
