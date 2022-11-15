import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MySocketIOPage extends StatefulWidget {
  const MySocketIOPage({
  super.key,
  required this.title,
  });

  final String title;

  @override
  _MySocketIOPageState createState() => _MySocketIOPageState();
}

class _MySocketIOPageState extends State<MySocketIOPage> {
  final TextEditingController _controller = TextEditingController();
  late IO.Socket socket;

  void _sendMessage() {
    String messageText = _controller.text.trim();
    _controller.text = '';
    print(messageText);
    if (messageText != '') {
      var messagePost = {
        'message': messageText,
        'recipient': 'events',
        'time': DateTime.now().toUtc().toString().substring(0, 16)
      };
      socket.emit('events', messagePost);
    }
  }

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  Future<void> initSocket() async {
    print('Connecting to chat service');
    socket = IO.io('http://10.20.20.83:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      // 'query': {}
    });
    // socket.connect();
    socket.onConnect((_) {
      print('connected to websocket');
    });
    socket.on('events', (message) {
      print(message);
      setState(() {
        // MessagesModel.messages.add(message);
      });
    });
    socket.on('allChats', (messages) {
      print(messages);
      setState(() {
        // MessagesModel.messages.addAll(messages);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            // StreamBuilder(
            //   stream: _channel.stream,
            //   builder: (context, snapshot) {
            //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
            //   },
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}