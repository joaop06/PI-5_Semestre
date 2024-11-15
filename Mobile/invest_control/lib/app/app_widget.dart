import 'package:flutter/material.dart';
import '../screens/login/login_page.dart';
import '../screens/register/register_page.dart';
import '../screens/home/home_page.dart';
import 'package:invest_control/screens/edit_profile/edit_profile_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Usuários',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/edit-profile': (context) => const EditProfilePage()
      },
    );
  }
}
