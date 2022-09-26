import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              //navigate
            }),
      ]),
      body: Container(
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: const [Text('Home')],
      )),
    );
  }
}
