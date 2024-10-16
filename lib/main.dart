import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone_app/firebase_options.dart';
import 'package:twitter_clone_app/pages/login_page.dart';
import 'package:twitter_clone_app/services/auth/auth_gate.dart';
import 'package:twitter_clone_app/services/auth/login_or_register.dart';
import 'package:twitter_clone_app/services/database/database_provider.dart';
import 'package:twitter_clone_app/themes/dark_mode.dart';
import 'pages/home_page.dart';
import 'themes/theme_provider.dart';

void main() async {
  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        // theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),

        // database provider
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
