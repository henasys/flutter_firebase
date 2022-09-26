import 'package:flutter/material.dart';

import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  bool _showSignInScreen = true;

  void toggleView() {
    setState(() {
      _showSignInScreen = !_showSignInScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: _showSignInScreen
          ? SignInScreen(toggleView: toggleView)
          : SignUpScreen(toggleView: toggleView),
    );
  }
}
