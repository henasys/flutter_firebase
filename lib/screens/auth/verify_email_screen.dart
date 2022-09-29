import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/services/auth_service.dart';

import '../../common/utils.dart';
import '../home/home_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _emailVerified = false;
  bool _canResendEmail = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!_emailVerified) {
      _sendVerificationEmail();
      _timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_emailVerified) {
      return const HomeScreen();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              'A verification email has been sent to your email.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _canResendEmail ? _sendVerificationEmail : null,
              child: _canResendEmail
                  ? const Text('Resent Email')
                  : const Text('Hold on...'),
            ),
            const SizedBox(height: 40),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () async {
                _timer?.cancel();
                final user = FirebaseAuth.instance.currentUser!;
                await AuthService().signOut(user);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }

    setState(() {
      _canResendEmail = false;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _canResendEmail = true;
    });
  }

  Future _checkEmailVerified() async {
    // call after email verification!
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      _emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (_emailVerified) {
      _timer?.cancel();
    }
  }
}
