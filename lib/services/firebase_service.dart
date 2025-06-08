import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcı verilerini kaydet (kayıt sırasında çağır)
  static Future<void> saveUserData({
    required String email,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Su verisi ekle (örnek)
  static Future<void> addWaterEntry(int glasses) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('water')
        .add({
      'count': glasses,
      'date': Timestamp.now(),
    });
  }

  // Uyku verisi ekle (örnek)
  static Future<void> addSleepEntry({
    required DateTime sleep,
    required DateTime wake,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('sleep')
        .add({
      'sleepTime': sleep,
      'wakeTime': wake,
      'date': Timestamp.now(),
    });
  }

  // Adım verisi ekle (örnek)
  static Future<void> addStepEntry(int steps) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('steps')
        .add({
      'stepCount': steps,
      'date': Timestamp.now(),
    });
  }
}
