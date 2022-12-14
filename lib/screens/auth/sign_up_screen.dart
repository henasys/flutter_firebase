import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../common/utils.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback toggleView;

  const SignUpScreen({Key? key, required this.toggleView}) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
              label: const Text('Sign In'),
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
                            : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: handleForSignUp,
                        child: const Text('Sign Up'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> handleForSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await AuthService().createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } on Exception catch (e) {
        print(e);
        const message =
            'The email address is already in use by another account.';
        Utils.showSnackBar(message);
      }
    }
  }
}
