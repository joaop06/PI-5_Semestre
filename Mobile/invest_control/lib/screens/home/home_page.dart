import 'package:flutter/material.dart';

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

  String? _riskResult;

  void _calculateRisk() {
    final low = double.tryParse(_lowController.text) ?? 0.0;
    final high = double.tryParse(_highController.text) ?? 0.0;
    final open = double.tryParse(_openController.text) ?? 0.0;
    final close = double.tryParse(_closeController.text) ?? 0.0;
    final volume = int.tryParse(_volumeController.text) ?? 0;

    if (low == 0 || high == 0 || open == 0 || close == 0 || volume == 0) {
      setState(() {
        _riskResult = 'Por favor, preencha todos os campos corretamente.';
      });
      return;
    }

    // Cálculo simples de risco (customize como necessário)
    final volatility = (high - low) / open;
    final risk = volatility * volume;

    setState(() {
      _riskResult = 'O risco estimado do investimento é de ${risk.toStringAsFixed(2)}.';
    });
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _editProfile() {
    Navigator.pushNamed(context, '/edit-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Risco'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _lowController,
              decoration: const InputDecoration(
                labelText: 'Valor mais baixo (Low)',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _highController,
              decoration: const InputDecoration(
                labelText: 'Valor mais alto (High)',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _openController,
              decoration: const InputDecoration(
                labelText: 'Valor de abertura (Open)',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _closeController,
              decoration: const InputDecoration(
                labelText: 'Valor de fechamento (Close)',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              onPressed: _calculateRisk,
              child: const Text('Calcular Risco'),
            ),
            const SizedBox(height: 16),
            if (_riskResult != null)
              Text(
                _riskResult!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}