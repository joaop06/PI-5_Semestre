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
  final AuthService _authService = AuthService();

  bool _isSending = false;

void _sendCryptoData() async {
  if (_isSending) return;

  setState(() {
    _isSending = true;
    _responseResult = ''; 
  });

  final data = {
    "low": double.tryParse(_lowController.text) ?? 0.0,
    "high": double.tryParse(_highController.text) ?? 0.0,
    "open": double.tryParse(_openController.text) ?? 0.0,
    "close": double.tryParse(_closeController.text) ?? 0.0,
    "volume": int.tryParse(_volumeController.text) ?? 0,
  };

  if (data.values.contains(0)) {
    setState(() {
      _responseResult = 'Por favor, preencha todos os campos corretamente.';
      _isSending = false; 
    });
    return;
  }

  try {
    final token = await _authService.getAccessToken();
    print('Token recuperado: $token');
    if (token == null) {
      setState(() {
        _responseResult = 'Erro: Token de acesso não encontrado. Faça login novamente.';
        _isSending = false;
      });
      return;
    }

    final response = await _apiService.postCryptoRisk(data, token);
    print('Resposta da API: $response');

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
  await _authService.logout(); 
  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
      body: SingleChildScrollView(  
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
                ? CircularProgressIndicator(color: Colors.white)
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
