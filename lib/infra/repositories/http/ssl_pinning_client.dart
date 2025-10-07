import 'dart:io';      
import 'dart:convert'; 
import 'dart:developer' as developer; // <<< CORRIGIDO
import 'package:crypto/crypto.dart'; 

class SslPinningClient {

  // 1. O PIN: HASH SHA-256 DO MOCKOON
  // debian: 4E78214717132A545A8B139BDDC2FDDE0C4A8612E8517C531DB4C9F714F9B5A4
  // mockoon: 7DEDF94AB648D12EF68B61787E1D4C612AA595FB8E19D5D5B61FE67F20F40107
  static const String _allowedSHA256Fingerprint = '4E78214717132A545A8B139BDDC2FDDE0C4A8612E8517C531DB4C9F714F9B5A4'; 


  // 2. ENDPOINT BASE (Regra 5)
  static const String _baseUrlx = 'https://10.0.2.2:8088/sisbedev/v1/';
  static const String _baseUrl = 'https://192.168.1.100:8088/sisbedev/v1/';
  
  
  /// Cria e configura o HttpClient nativo com a lógica de Pinning.
  static HttpClient createHttpClientWithPinning() {
    final HttpClient httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 5); 
    
    // 3. Implementação do Pinning: badCertificateCallback
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      
      // Cálculo do hash SHA-256 a partir do binário (cert.der)
      final receivedHashBytes = sha256.convert(cert.der).bytes;
      
      // Converte para string hexadecimal (sem ':')
      final String receivedFingerprint = receivedHashBytes
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join()
          .toUpperCase();
      
      final String expectedFingerprint = _allowedSHA256Fingerprint.toUpperCase().replaceAll(':', '');

      final bool isPinned = receivedFingerprint == expectedFingerprint;

      // Loga o resultado da segurança (usando o alias developer)
      if (isPinned) {
        developer.log('✅ SUCESSO: Hash do certificado bateu. Conexão Permitida.', name: 'SSL Pinning');
      } else {
        developer.log('❌ FALHA: Hash fixado NÃO corresponde. Conexão BLOQUEADA.', name: 'SSL Pinning');
        developer.log('Esperado: $expectedFingerprint | Recebido: $receivedFingerprint', name: 'SSL Pinning');
      }

      return isPinned;
    };

    return httpClient;
  }


  /// Executa GET /health usando o HttpClient configurado.
  static Future<Map<String, dynamic>> getHealthCheck() async {
    const String path = 'health';
    final Uri uri = Uri.parse('$_baseUrl$path');
    
    final HttpClient client = createHttpClientWithPinning();
    
    final Map<String, String> headers = {
      'Authorization': 'Bearer test-token',
      'contaId': '1',
      'empresaId': '1',
      'Content-Type': 'application/json',
    };

    HttpClientRequest? request;
    try {
      request = await client.getUrl(uri).timeout(const Duration(seconds: 5));
      
      // Regra 9: Logging antes da chamada (usando o alias developer)
      developer.log('--- API Call ---', name: 'HTTP Request');
      developer.log('VERBO: GET', name: 'HTTP Request');
      developer.log('URL: $uri', name: 'HTTP Request');
      developer.log('HEADERS: $headers', name: 'HTTP Request');

      headers.forEach((key, value) {
        request!.headers.set(key, value);
      });

      final HttpClientResponse response = await request.close();
      
      final responseBody = await response.transform(utf8.decoder).join();
      
      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(responseBody),
      };

    } finally {
      client.close(); 
    }
  }
}