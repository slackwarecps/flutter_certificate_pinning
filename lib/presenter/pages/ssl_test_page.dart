import 'dart:io'; 
import 'dart:developer' as developer; // <<< CORRIGIDO
import 'package:flutter/material.dart';
import 'package:gemini_ola_mundo/infra/repositories/http/ssl_pinning_client.dart';


class SslTestPage extends StatefulWidget {
  const SslTestPage({super.key});

  @override
  State<SslTestPage> createState() => _SslTestPageState();
}

class _SslTestPageState extends State<SslTestPage> {
  String _statusMessage = 'Aguardando o teste de Pinning (Puro Dart)...';

  Future<void> _testSslPinning() async {
    setState(() => _statusMessage = 'Tentando conectar e validar o Pinning...');

    try {
      final Map<String, dynamic> result = await SslPinningClient.getHealthCheck();
      
      final int statusCode = result['statusCode'];

      if (statusCode == 200) {
        developer.log('Teste concluído com Status 200.', name: 'SSL Test Page');
        setState(() => _statusMessage = '✅ SUCESSO! Conexão Segura e /health OK! (Status: $statusCode)');
      } else {
        setState(() => _statusMessage = '⚠️ Requisição falhou (Status: $statusCode). Segurança OK, mas servidor retornou erro.');
      }

    } on SocketException {
        // Loga o erro de segurança (usando o alias developer)
        developer.log('Erro de Socket: Conexão Bloqueada.', name: 'SSL Test Page Error');
        setState(() {
             _statusMessage = '❌ FALHA DE SEGURANÇA: A conexão foi bloqueada. Verifique o Hash (Pin) no SslPinningClient.';
        });
    } catch (e) {
      developer.log('Erro Inesperado: $e', name: 'SSL Test Page Error');
      setState(() => _statusMessage = '❌ ERRO GERAL: $e');
    }
  }

  // ... (O restante do código de UI) ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste de Certificate Pinning (Puro Dart)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _statusMessage, 
              textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: 16,
                color: _statusMessage.contains('SUCESSO') ? Colors.green.shade700 : 
                       _statusMessage.contains('❌') ? Colors.red.shade700 : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _testSslPinning,
              icon: const Icon(Icons.security),
              label: const Text('Executar Teste GET /health'),
            ),
          ],
        ),
      ),
    );
  }
}