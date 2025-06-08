import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/step_card.dart';
import '../widgets/water_card.dart';
import '../widgets/sleep_card.dart';
import '../widgets/weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double temperature = 0.0;
  String city = "İstanbul";
  String description = "";

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=41.01&longitude=28.97&current_weather=true');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = data['current_weather']['temperature'].toDouble();
          description = "Güncel sıcaklık verisi";
        });
      } else {
        debugPrint("API isteği başarısız: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Hava durumu verisi alınamadı: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Günlük Takip"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeatherCard(
              temperature: temperature,
              city: city,
              description: description,
            ),
            const SizedBox(height: 16),
            const StepCard(),
            const SizedBox(height: 16),
            const WaterCard(),
            const SizedBox(height: 8),
            const Text(
              "💡 Su hedefinizi Hatırlatıcı sayfasından belirleyebilirsiniz.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const SleepCard(),
          ],
        ),
      ),
    );
  }
}
