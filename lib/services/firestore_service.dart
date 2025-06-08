import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ ADIM VERİSİ KAYDETME
  static Future<void> saveStepData({required int steps}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final todayId = _todayDocId();

    await _db
        .collection("users")
        .doc(user.uid)
        .collection("steps")
        .doc(todayId)
        .set({
      "steps": steps,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // ✅ ADIM VERİSİ GETİRME
  static Future<int> getStepData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final doc = await _db
        .collection("users")
        .doc(user.uid)
        .collection("steps")
        .doc(_todayDocId())
        .get();

    return doc.exists ? (doc.data()?["steps"] ?? 0) as int : 0;
  }

  // ✅ SU VERİSİ KAYDETME
  static Future<void> saveWaterData({required int cups}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db
        .collection("users")
        .doc(user.uid)
        .collection("water")
        .doc(_todayDocId())
        .set({
      "cups": cups,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // ✅ SU VERİSİ GETİRME
  static Future<int> getWaterData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final doc = await _db
        .collection("users")
        .doc(user.uid)
        .collection("water")
        .doc(_todayDocId())
        .get();

    return doc.exists ? (doc.data()?["cups"] ?? 0) as int : 0;
  }

  // ✅ UYKU VERİSİ KAYDETME
  static Future<void> saveSleepData({
    required String sleepTime,
    required String wakeTime,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db
        .collection("users")
        .doc(user.uid)
        .collection("sleep")
        .doc(_todayDocId())
        .set({
      "sleepTime": sleepTime,
      "wakeTime": wakeTime,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // ✅ UYKU VERİSİ GETİRME
  static Future<Map<String, String>> getSleepData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final doc = await _db
        .collection("users")
        .doc(user.uid)
        .collection("sleep")
        .doc(_todayDocId())
        .get();

    if (doc.exists) {
      final data = doc.data();
      return {
        "sleepTime": data?["sleepTime"] ?? "00:00",
        "wakeTime": data?["wakeTime"] ?? "00:00",
      };
    }

    return {};
  }

  // ✅ UYKU SÜRESİ (saat) HESAPLAMA – İstatistik grafiğinde gösterilir
  static Future<double> getSleepHours() async {
    final data = await getSleepData();
    if (data.isEmpty) return 0;

    final now = DateTime.now();
    final sleepParts = data["sleepTime"]!.split(":").map(int.parse).toList();
    final wakeParts = data["wakeTime"]!.split(":").map(int.parse).toList();

    final sleep = DateTime(now.year, now.month, now.day, sleepParts[0], sleepParts[1]);
    DateTime wake = DateTime(now.year, now.month, now.day, wakeParts[0], wakeParts[1]);

    if (wake.isBefore(sleep)) {
      wake = wake.add(const Duration(days: 1));
    }

    final diff = wake.difference(sleep);
    return diff.inMinutes / 60; // double saat cinsinden
  }

  // 🔧 Ortak metod: Bugünün tarih ID'si (örneğin: "2024-05-31")
  static String _todayDocId() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
