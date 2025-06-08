import 'package:flutter/material.dart';
import '../notification_service.dart';

class TestNotificationPage extends StatelessWidget {
  const TestNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bildirim Testi")),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.notification_add),
          label: const Text("Bildirim Gönder"),
          onPressed: () {
            NotificationService.showNotification(
              title: "🧊 Su İçmeyi Unutma!",
              body: "Hedefine ulaşmak için bir bardak su iç 💧",
            );
          },
        ),
      ),
    );
  }
}
