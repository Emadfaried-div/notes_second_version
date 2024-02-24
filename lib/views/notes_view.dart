import 'package:flutter/material.dart';
import 'package:trials2/services/auth/auth_service.dart';
import '../constants/routs.dart';
import '../enums/menu_action.dart';

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
                    await AuthService.firebase().logOut();

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
