import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/predictor_service.dart';

class MlResultCard extends StatefulWidget {
  const MlResultCard({super.key});

  @override
  State<MlResultCard> createState() => _MlResultCardState();
}

class _MlResultCardState extends State<MlResultCard> {
  String result = "Yükleniyor...";

  @override
  void initState() {
    super.initState();
    _loadClassification();
  }

  Future<void> _loadClassification() async {
    final steps = await FirestoreService.getStepData();
    final sleepHours = await FirestoreService.getSleepHours();

    await PredictorService.loadModel();
    final classification = PredictorService.classify(steps.toDouble(), sleepHours);

    setState(() {
      result = classification;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.analytics, size: 32, color: Colors.indigo),
        title: const Text("Günlük Durum Analizi"),
        subtitle: Text("Sonuç: $result"),
      ),
    );
  }
}
