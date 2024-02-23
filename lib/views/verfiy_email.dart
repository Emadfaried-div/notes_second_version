

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/routs.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Email Verify",style: TextStyle(fontSize: 28,),),
        elevation: 0.0,
      ),
      body: Column(
        children: [

          Text("we've sent you an email verification, please open it to verify your account..",style: TextStyle(fontSize: 24,),),
          SizedBox(height: 50,),
          Text("if you haven't received a verification email yet, please press the button below",style: TextStyle(fontSize: 24),),
          TextButton(style: ButtonStyle(
            foregroundColor:
            MaterialStateProperty.all<Color>(Colors.blue),
          ), onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
            child: const Text("send email verification",style: TextStyle(fontSize: 24),),

          ),
          TextButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
          },
              child: Text("Restart",style: TextStyle(fontSize: 24,color: Colors.blue),),)
        ],
      ),
    );
  }
}
