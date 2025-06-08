import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _motivationalMessage = "";
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<String> _messages = [
    "Bol su, iyi zihin! 💧🧠",
    "Sağlık bir bardakla başlar.",
    "Bir bardak daha, hedefe daha yakın!",
    "Unutma, vücudunun %70'i sudan oluşur!",
    "İçtiğin her bardak seni tazeler 💪",
    "Bugün kendin için bir bardak su iç 💙",
  ];

  @override
  void initState() {
    super.initState();
    _generateMotivation();
  }

  void _generateMotivation() {
    final random = Random();
    setState(() {
      _motivationalMessage = _messages[random.nextInt(_messages.length)];
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('audio/motivation.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Kullanıcı: ${user?.email ?? "Bilinmiyor"}"),
              subtitle: const Text("Hoş geldin!"),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                label: const Text("Çıkış Yap"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text("🧠 Günün Motivasyon Mesajı:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              _motivationalMessage,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/map'),
              icon: const Icon(Icons.map),
              label: const Text("Haritayı Gör"), // ✅ Harita butonu
            ),
          ],
        ),
      ),
    );
  }
}
