import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:gemini_ola_mundo/domain/models/health_status.dart';

class SaudeRepository {
  final Dio _dio = Dio();

  Future<HealthStatus> getHealthStatus() async {
    const url = 'http://10.0.2.2:8088/sisbedev/v1/health';
    developer.log('GET: $url', name: 'SaudeRepository');

    try {
      final response = await _dio.get(url);
      developer.log('Response: ${response.data}', name: 'SaudeRepository');
      final data = response.data as Map<String, dynamic>;
      data['status'] = 'UP'; // Manually add status
      return HealthStatus.fromJson(data);
    } on DioException catch (e) {
      developer.log('Error fetching health status: $e', name: 'SaudeRepository', error: e);
      rethrow;
    }
  }
}
