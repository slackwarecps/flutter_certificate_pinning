import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemini_ola_mundo/presenter/pages/ssl_test_page.dart';

class PadariaPage extends StatelessWidget {
  const PadariaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Padaria'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => const SslTestPage());
          },
          child: const Text('btnPinning'),
        ),
      ),
    );
  }
}
