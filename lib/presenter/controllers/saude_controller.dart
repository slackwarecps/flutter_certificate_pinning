import 'package:get/get.dart';
import 'package:gemini_ola_mundo/domain/models/health_status.dart';
import 'package:gemini_ola_mundo/infra/repositories/saude_repository.dart';

class SaudeController extends GetxController {
  final SaudeRepository _repository = SaudeRepository();

  final status = Rx<HealthStatus?>(null);
  final isLoading = RxBool(false);
  final error = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchHealthStatus();
  }

  Future<void> fetchHealthStatus() async {
    try {
      isLoading.value = true;
      error.value = '';
      status.value = await _repository.getHealthStatus();
    } catch (e) {
      error.value = 'Erro ao buscar o status da API.';
      status.value = HealthStatus(status: 'ERROR');
    } finally {
      isLoading.value = false;
    }
  }
}
