import 'package:flutter/material.dart';
import 'package:websocket_test/main-socketio.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MySocketIOPage(
        title: title,
      ),
    );
  }
}