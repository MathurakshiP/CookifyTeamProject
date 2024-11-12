// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart'; // Import the Provider package
import 'providers/saved_food_provider.dart'; // Import SavedFoodProvider
import 'providers/shopping_list_provider.dart'; // Import ShoppingListProvider

void main() async {
  await dotenv.load();  // Load the .env file
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SavedFoodProvider()), // Provide SavedFoodProvider
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()), // Provide ShoppingListProvider
      ],
      child: MaterialApp(
        title: 'Recipe App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/home', // Set the initial screen (login screen)
        routes: {
          '/': (context) => LoginPage(), // Login screen route
          '/home': (context) => HomeScreen(), // Home screen route
        },
      ),
    );
  }
}
