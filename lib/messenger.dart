import 'package:flutter/material.dart';

class MessengerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messenger'),
      ),
      body: Center(
        child: Text(
          'Messenger Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
