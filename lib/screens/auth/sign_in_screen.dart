import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutterfirebase/common/utils.dart';
import 'package:lottie/lottie.dart';

import '../../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback toggleView;

  const SignInScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: const Icon(Icons.person),
              label: const Text('Sign Up'),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset('assets/images/calendar.json', width: 175),
              Text(
                'Yet another Todo list',
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                          controller: _emailController,
                          decoration:
                              const InputDecoration(hintText: 'Enter email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val == null || !val.contains('@')
                              ? 'Enter an email address'
                              : null),
                      const SizedBox(height: 20),
                      TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(hintText: 'Enter password'),
                          obscureText: true,
                          validator: (val) => val!.length < 6
                              ? 'Enter a password of '
                                  'at least 6 chars'
                              : null),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: handleForSignIn,
                          child: const Text('Sign In')),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('OR'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SignInButton(
                        Buttons.Google,
                        text: 'Sign in w/ Google',
                        // padding: const EdgeInsets.all(20),
                        onPressed: handleForSignInWithGoogle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> handleForSignInWithGoogle() async {
    try {
      final user = await AuthService().signInWithGoogle();
      print('Google: $user');
    } catch (e) {
      print(e);
      Utils.showSnackBar(e.toString());
    }
  }

  Future<void> handleForSignIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await AuthService().signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } on Exception catch (e) {
        print(e);
        const message = 'There is no user or wrong password';
        Utils.showSnackBar(message);
      }
    }
  }
}
