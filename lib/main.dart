import 'package:flutter/material.dart';
import 'package:trials2/services/auth/auth_service.dart';
import 'package:trials2/views/login.dart';
import 'package:trials2/views/notes_view.dart';
import 'package:trials2/views/register_view.dart';
import 'package:trials2/views/verfiy_email.dart';
import 'dart:developer'as devtools show log;
import 'constants/routs.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
      initialRoute: loginRoute,
      routes: {
        loginRoute: (context) => LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        emailVerifyRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  devtools.log("Email is verified");
                  return NotesView();
                } else {
                  return VerifyEmailView();
                }
              } else {
                return LoginView();
              }

            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}


