import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String _error = '';

  Future<void> _handleAuth() async {
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // ✅ Kayıt sonrası formu temizle ve login moduna geç
        _emailController.clear();
        _passwordController.clear();
        setState(() {
          _isLogin = true;
          _error = '';
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Kaydınız başarıyla oluşturuldu. Giriş yapabilirsiniz."),
            ),
          );
        }

        return;
      }

      setState(() => _error = '');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Kullanıcı bulunamadı.';
          break;
        case 'wrong-password':
          message = 'Şifre yanlış.';
          break;
        case 'invalid-email':
          message = 'Geçersiz e-posta adresi.';
          break;
        case 'email-already-in-use':
          message = 'Bu e-posta zaten kayıtlı.';
          break;
        case 'weak-password':
          message = 'Şifre çok zayıf.';
          break;
        default:
          message = 'Hata: ${e.message}';
      }
      setState(() => _error = message);
    } catch (_) {
      setState(() => _error = 'Bilinmeyen bir hata oluştu.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Giriş Yap' : 'Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Şifre'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleAuth,
              child: Text(_isLogin ? 'Giriş Yap' : 'Kayıt Ol'),
            ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin
                  ? 'Hesabın yok mu? Kayıt Ol'
                  : 'Zaten hesabın var mı? Giriş Yap'),
            ),
            const SizedBox(height: 12),
            if (_error.isNotEmpty)
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
