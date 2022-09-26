import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final name = user != null? user.email : '';
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              //navigate
            }),
      ]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Home", style: Theme.of(context).textTheme.headline5,),
          const SizedBox(height: 20,),
          Text("$name is logged in", style: Theme.of(context).textTheme.headline6,)
        ],
      )),
    );
  }
}
