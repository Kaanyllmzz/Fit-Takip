import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'pages/home_page.dart';
import 'pages/statistics_page.dart';
import 'pages/water_reminder_page.dart';
import 'pages/settings_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'notification_service.dart';
import 'providers/app_provider.dart';
import 'providers/theme_provider.dart'; // ✅ yeni eklendi

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await NotificationService.initialize();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);
  final token = await messaging.getToken();
  print("🔑 Cihaz token: $token");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      NotificationService.showNotification(
        title: message.notification!.title ?? "Bildirim",
        body: message.notification!.body ?? "",
      );
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ✅ eklendi
      ],
      child: const FitTakipApp(),
    ),
  );
}

class FitTakipApp extends StatelessWidget {
  const FitTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final themeProvider = Provider.of<ThemeProvider>(context); // ✅

    return MaterialApp(
      title: 'FitTakip',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // ✅ destek
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: isLoggedIn ? '/' : '/login',
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    StatisticsPage(),
    WaterReminderPage(),
    SettingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Takip"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "İstatistik"),
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: "Hatırlatıcı"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
