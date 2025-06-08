import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart'; // ✅ eklendi
import '../providers/theme_provider.dart'; // ✅ Tema sağlayıcısı

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _appVersion = "Yükleniyor..."; // ✅ Versiyon bilgisi

  @override
  void initState() {
    super.initState();
    _loadVersion(); // ✅
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "v${info.version} (${info.buildNumber})";
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text("Bildirimleri Aç"),
            subtitle: const Text("Su hatırlatmaları vs."),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("🌙 Karanlık Mod"),
            subtitle: const Text("Uygulama temasını değiştir"),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Dil Seçimi"),
            subtitle: const Text("Türkçe"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Dili seçmek için dialog eklenebilir
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Uygulama Sürümü"),
            subtitle: Text(_appVersion),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("FitTakip"),
                  content: Text("Bu uygulamanın sürümü: $_appVersion\n\nHer zaman güncel kalın!"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Tamam"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
