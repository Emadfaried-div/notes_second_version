import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:trials2/constants/routs.dart';
import 'package:trials2/utilities/showerrordialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(
        title: Text("Register",style: TextStyle(fontSize: 28),),
        elevation: 0.0,
        backgroundColor: Colors.blue[400],
      ),
      body: SingleChildScrollView (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        .createUserWithEmailAndPassword(
                        email: email, password: password);
                     final user = FirebaseAuth.instance.currentUser;
                     await user?.sendEmailVerification();
                      Navigator.of(context).pushNamed(emailVerifyRoute);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "weak-password") {
                      {
                        await showErrorDialog(context, "weak-password",);

                      }
                    } else if (e.code == "email-already-in-use") {
                      await showErrorDialog(context, "Email is Already in use",);

                    } else if (e.code == "invalid-email") {
                      await showErrorDialog(context, "invalid-email",);

                    }else {
                      // Handle other FirebaseAuthException codes or generic error
                      await showErrorDialog(context, "An error occurred: ${e.message}"); // Use `await` if necessary
                    }
                  }
                  catch (e){
                    await showErrorDialog(context, "An error occurred: ${e.toString()}");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, color: Colors.grey[900],
                      // Adjust color as needed
                      size: 30.0,),
                    Text("Register", style: TextStyle(fontSize: 28),),
                  ],
                )),
            TextButton(onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);

            },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login),
                    Text ("Have an account! Login here.",style: TextStyle(color: Colors.blueAccent,fontSize: 22.0),),
                  ],
                )),
          ],
        ),
      ),
    );
  }

}