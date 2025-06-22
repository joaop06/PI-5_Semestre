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
      if (token == null) {
        setState(() {
          _responseResult =
              'Erro: Token de acesso não encontrado. Faça login novamente.';
          _isSending = false;
        });
        return;
      }

      final response = await _apiService.postCryptoRisk(data, token);

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
          'CryptoInsight',
          style: TextStyle(
            color: Colors.amber[400],
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white70),
            onPressed: _editProfile,
            tooltip: 'Editar Usuário',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título da tela
              Row(
                children: [
                  Icon(Icons.analytics, color: Colors.amber[400], size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'Análise de Criptomoedas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _lowController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                    'Valor mais baixo (Low)', Icons.arrow_downward),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _highController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                    'Valor mais alto (High)', Icons.arrow_upward),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _openController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                    'Valor de abertura (Open)', Icons.play_arrow),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _closeController,
                style: const TextStyle(color: Colors.white),
                decoration:
                    _inputDecoration('Valor de fechamento (Close)', Icons.stop),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _volumeController,
                style: const TextStyle(color: Colors.white),
                decoration:
                    _inputDecoration('Volume', Icons.stacked_line_chart),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _sendCryptoData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.amber[400],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSending
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Enviar Dados',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              if (_responseResult != null && _responseResult!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[400]?.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _responseResult!,
                    style: TextStyle(
                      color: _responseResult!.startsWith('Erro')
                          ? Colors.red[300]
                          : Colors.amber[400],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
