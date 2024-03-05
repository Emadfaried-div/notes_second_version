import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trials2/constants/routs.dart';
import 'package:trials2/services/auth/auth_service.dart';
import '../services/auth/auth_exceptions.dart';
import '../utilities/showerrordialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],
      appBar: AppBar(
        title: Text("Login"),
        elevation: 0.0,
        backgroundColor: Colors.blue[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  InputDecoration(hintText: "Enter your email here....."),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  InputDecoration(hintText: "Enter your password here..."),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().login(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    //if user email verified ..
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  } else {
                    //if user emil NOT verified..
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        emailVerifyRoute, (route) => false);
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    "User not found.",
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    "Incorrect password.",
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                      context, "An error occurred: Authentication error");
                }
              },
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      color: Colors.grey[900], // Adjust color as needed
                      size: 20.0, // Adjust size as needed   3
                    ),
                    const Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute, (route) => false);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.app_registration),
                            Text(
                              "Not register yet? Register here.",
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 19.0),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
