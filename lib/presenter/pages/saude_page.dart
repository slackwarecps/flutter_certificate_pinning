import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemini_ola_mundo/presenter/controllers/saude_controller.dart';

class SaudePage extends StatelessWidget {
  const SaudePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Injetando o controller se ainda não foi injetado
    final SaudeController controller = Get.put(SaudeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status da API'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }

          if (controller.error.isNotEmpty) {
            return Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            );
          }

          final status = controller.status.value;
          if (status == null) {
            return const Text('Nenhum dado de status encontrado.');
          }

          final apiStatus = status.status;
          final statusColor = apiStatus == 'UP' ? Colors.green : Colors.red;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Status: $apiStatus',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text('API: ${status.name ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Descrição: ${status.description ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Versão: ${status.version ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.fetchHealthStatus(),
        tooltip: 'Recarregar',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
