import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart'; // ✅ Ses için
import '../services/firestore_service.dart';

class StepCard extends StatefulWidget {
  const StepCard({super.key});

  @override
  State<StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  int _steps = 0;
  final int _goal = 5000;
  final AudioPlayer _audioPlayer = AudioPlayer(); // ✅ Ses oynatıcı
  bool _playedSound = false; // ✅ Ses sadece bir kez çalsın

  @override
  void initState() {
    super.initState();
    _loadInitialSteps();
  }

  Future<void> _loadInitialSteps() async {
    final stepsFromDb = await FirestoreService.getStepData();
    setState(() {
      _steps = stepsFromDb;
      _playedSound = _steps >= 7000;
    });
  }

  void _incrementSteps() async {
    setState(() {
      _steps += 100;
    });

    if (_steps >= 7000 && !_playedSound) {
      _playedSound = true;
      await _audioPlayer.play(AssetSource('audio/motivation.mp3'));
    }

    await FirestoreService.saveStepData(steps: _steps);
  }

  String getActivityLevel(int steps) {
    if (steps < 3000) return "Pasif";
    if (steps < 7000) return "Orta Aktif";
    return "Aktif";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.directions_walk, size: 32, color: Colors.green),
            title: const Text("Adım Sayısı"),
            subtitle: Text("Bugün $_steps adım attınız"),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _incrementSteps,
              color: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 12),
            child: Text(
              "Aktivite Durumu: ${getActivityLevel(_steps)}",
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),
    );
  }
}
