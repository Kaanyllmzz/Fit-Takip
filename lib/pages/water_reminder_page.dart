import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notification_service.dart';
import 'dart:async';

class WaterReminderPage extends StatefulWidget {
  const WaterReminderPage({super.key});

  @override
  State<WaterReminderPage> createState() => _WaterReminderPageState();
}

class _WaterReminderPageState extends State<WaterReminderPage> {
  int waterCount = 0;
  int dailyGoal = 8;
  final TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWaterCount();
    _loadDailyGoal();

    Future.delayed(const Duration(seconds: 2), () {
      NotificationService.showNotification(
        title: "Hoş Geldin!",
        body: "Günlük su hedefini takip etmeyi unutma 💧",
      );
    });
  }

  Future<void> _loadWaterCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      waterCount = prefs.getInt('waterCount') ?? 0;
    });
  }

  Future<void> _saveWaterCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterCount', waterCount);
  }

  Future<void> _loadDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyGoal = prefs.getInt('dailyGoal') ?? 8;
      _goalController.text = dailyGoal.toString();
    });
  }

  Future<void> _saveDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final int? goal = int.tryParse(_goalController.text);
    if (goal != null && goal > 0) {
      await prefs.setInt('dailyGoal', goal);
      setState(() {
        dailyGoal = goal;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hedef başarıyla kaydedildi ✅")),
      );
    }
  }

  void _increment() {
    setState(() {
      if (waterCount < dailyGoal) waterCount++;
    });
    _saveWaterCount();
  }

  void _decrement() {
    setState(() {
      if (waterCount > 0) waterCount--;
    });
    _saveWaterCount();
  }

  void _reset() {
    setState(() {
      waterCount = 0;
    });
    _saveWaterCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Su Hatırlatıcı"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Günlük Su Takibi",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Hedefiniz: $dailyGoal bardak",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                "$waterCount / $dailyGoal bardak",
                style: const TextStyle(fontSize: 48, color: Colors.blue),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _decrement,
                    icon: const Icon(Icons.remove_circle),
                    iconSize: 40,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    onPressed: _increment,
                    icon: const Icon(Icons.add_circle),
                    iconSize: 40,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _goalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Günlük hedef bardak sayısı",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _saveDailyGoal,
                icon: const Icon(Icons.save),
                label: const Text("Hedefi Kaydet"),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _reset,
                child: const Text("Sıfırla"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
