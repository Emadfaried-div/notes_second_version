
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer'as devtools show log;
import 'package:flutter/material.dart';





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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Login"),
        elevation: 0.0,
        backgroundColor: Colors.blue[400],
      ),
      body: SingleChildScrollView (
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
                foregroundColor:
                MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                   await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: email, password: password);
                  devtools.log("You are logged_in successfully.");
                  Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false);
                } on FirebaseAuthException  {
                  // Handle both "user-not-found" and "wrong-password" cases:
                  devtools.log("Invalid email or password. Please try again.");
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
                    SizedBox(height: 100.0,),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);

                    },
                        child: const Row(
                          mainAxisAlignment:MainAxisAlignment.center ,
                          children: [
                            Icon(Icons.app_registration),
                            Text ("Not register yet? Register here.",style: TextStyle(color: Colors.blueAccent,fontSize: 19.0),),
                          ],
                        )),
                  ],
                ),
              ),)

          ],
        ),
      ),
    );
  }
}