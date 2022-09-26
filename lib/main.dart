import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/auth/authenticate_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('There was an error'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => AuthenticateScreen(),
              '/home': (context) => HomeScreen(),
            },
            theme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Colors.black,
                appBarTheme: AppBarTheme(backgroundColor: Colors.black),
                iconTheme: IconThemeData(color: Colors.white),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent, textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                  ),
                ),
                dividerColor: Colors.grey[600]),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
