import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './blocs/providers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Login BLoC Demo',
        home: Scaffold(body: LoginScreen()),
      ),
    );
  }
}
