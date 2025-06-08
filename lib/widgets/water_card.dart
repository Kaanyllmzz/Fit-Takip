import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';


class WaterCard extends StatefulWidget {
  const WaterCard({super.key});

  @override
  State<WaterCard> createState() => _WaterCardState();
}

class _WaterCardState extends State<WaterCard> {
  int _drankCups = 0;
  int _goalCups = 8;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final goal = prefs.getInt('dailyGoal') ?? 8;
    final cupsFromDb = await FirestoreService.getWaterData();

    setState(() {
      _goalCups = goal;
      _drankCups = cupsFromDb;
    });
  }

  void _incrementCup() async {
    if (_drankCups < _goalCups) {
      setState(() {
        _drankCups++;
      });
      await FirestoreService.saveWaterData(cups: _drankCups);
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = _goalCups == 0 ? 0 : _drankCups / _goalCups;

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: _incrementCup,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                leading: Icon(Icons.local_drink, size: 32, color: Colors.blue),
                title: Text("Su Tüketimi"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("İçilen: $_drankCups / $_goalCups bardak"),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("🖐️ Tıklayarak içtiğini kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
