import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    // print('user: $user');
    // print('user: ${user?.providerData.length}');
    // print('user: ${user?.providerData}');
    final email = user != null ? user.email : '';
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), actions: [
        IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut(user);
              //navigate
            }),
      ]),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "$email",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "logged in",
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: user?.providerData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final providerId = user?.providerData[index].providerId;
                      if (providerId != null) {
                        return Text(
                          'providerId $providerId',
                          style: Theme.of(context).textTheme.headline6,
                        );
                      }
                      return const Text('no providerId');
                    }),
              )
            ],
          )),
    );
  }
}
