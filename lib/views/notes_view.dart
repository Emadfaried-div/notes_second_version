
import 'package:flutter/material.dart';
class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Text("Hello"),
        ],
      ),
    );
  }
}
