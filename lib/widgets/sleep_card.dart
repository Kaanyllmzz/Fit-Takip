import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class SleepCard extends StatefulWidget {
  const SleepCard({super.key});

  @override
  State<SleepCard> createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard> {
  TimeOfDay? sleepTime;
  TimeOfDay? wakeTime;

  @override
  void initState() {
    super.initState();
    _loadSleepData(); // ✅ Firestore'dan çek
  }

  Future<void> _loadSleepData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final todayId = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('sleep')
        .doc(todayId)
        .get();

    if (doc.exists) {
      final data = doc.data();
      final sleepParts = (data?['sleepTime'] ?? "00:00").split(":");
      final wakeParts = (data?['wakeTime'] ?? "00:00").split(":");

      setState(() {
        sleepTime = TimeOfDay(
            hour: int.parse(sleepParts[0]), minute: int.parse(sleepParts[1]));
        wakeTime = TimeOfDay(
            hour: int.parse(wakeParts[0]), minute: int.parse(wakeParts[1]));
      });
    }
  }

  String get sleepSummary {
    if (sleepTime == null || wakeTime == null) {
      return "Henüz giriş yapılmadı";
    }

    final now = DateTime.now();
    final sleepDateTime = DateTime(
        now.year, now.month, now.day, sleepTime!.hour, sleepTime!.minute);
    DateTime wakeDateTime = DateTime(
        now.year, now.month, now.day, wakeTime!.hour, wakeTime!.minute);

    if (wakeDateTime.isBefore(sleepDateTime)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }

    final diff = wakeDateTime.difference(sleepDateTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    return "Dün gece $hours saat $minutes dakika uyudunuz\n${getSleepFeedback(hours)}";
  }

  String getSleepFeedback(int hours) {
    if (hours < 5) return "Çok az uyku 😴";
    if (hours < 7) return "Orta seviye 💤";
    return "Verimli uyku ✅";
  }

  Future<void> _pickTime(bool isSleepTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isSleepTime) {
          sleepTime = picked;
        } else {
          wakeTime = picked;
        }
      });

      if (sleepTime != null && wakeTime != null) {
        await FirestoreService.saveSleepData(
          sleepTime: "${sleepTime!.hour}:${sleepTime!.minute}",
          wakeTime: "${wakeTime!.hour}:${wakeTime!.minute}",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.bedtime, size: 32, color: Colors.purple),
            title: Text("Uyku Süresi"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(sleepSummary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickTime(true),
                icon: const Icon(Icons.login),
                label: const Text("Yatma Saati"),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickTime(false),
                icon: const Icon(Icons.logout),
                label: const Text("Uyanma Saati"),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
