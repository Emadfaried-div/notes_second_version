

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:trials2/views/login.dart';
import 'package:trials2/views/register_view.dart';
import 'package:trials2/views/verfiy_email.dart';
import 'dart:developer'as devtools show log;
import 'constants/routs.dart';
import 'firebase_options.dart';

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
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  devtools.log("Email is verified");
                  return NotesView();
                } else {
                  return VerfiyEmailView();
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

enum MenuActon { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          "Main UI",
          style: TextStyle( fontSize: 25),
        ),
        actions: [
          PopupMenuButton<MenuActon>(
            onSelected: (value) async {
              switch (value) {
                case MenuActon.logout:
                  final shouldlogout = await showLogOutDialog(context);
                  if (shouldlogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuActon>(
                  value: MenuActon.logout,
                  child: Text("logout"),
                ),
              ];
            },
          )
        ],
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
      ),
      body: const Text("hello world "),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Log Out"),
        content: const Text("are you sure you want to log_out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Log Out"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
