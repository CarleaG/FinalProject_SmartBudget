// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './login.dart';
import './tabs.dart';
import './signup.dart';
import './state.dart'; // Import your state management

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseState(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Poppins', // Add this line to set the default font family
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/tabs': (context) => MyTabs(),
          '/signup': (context) => SignupPage(),
        },
      ),
    ),
  );
}
