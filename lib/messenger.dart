import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:file_picker/file_picker.dart';

class MessagesScreen extends StatefulWidget {
  final String conversationId; // Add conversationId parameter

  MessagesScreen(
      {required this.conversationId}); // Constructor with conversationId parameter

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<dynamic> messages = []; // List to store fetched messages
  late String conversationId; // Variable to store conversationId
  late IO.Socket socket;
  late TextEditingController
      _textEditingController; // Controller for the text field

  @override
  void initState() {
    super.initState();
    conversationId =
        widget.conversationId; // Initialize conversationId from widget
    fetchMessages(); // Fetch messages when the widget initializes
    connectToSocket();
    _textEditingController =
        TextEditingController(); // Initialize text field controller
  }

  @override
  void dispose() {
    _textEditingController.dispose(); // Dispose the controller
    super.dispose();
  }

  Future<void> fetchMessages() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:9090/conversations/$conversationId/messages'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        messages = responseData['messages'];
      });
    } else {
      // If the server did not return a 200 OK response, throw an error.
      throw Exception('Failed to load messages');
    }
  }

  void connectToSocket() {
    socket = IO.io('http://10.0.2.2:9090', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket.io server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket.io server');
    });

    socket.on('new_message', (data) {
      print('New message received: $data');
      setState(() {
        messages.add(data); // Add the new message to the list
      });
    });
  }

  void sendMessage(String message) {
    socket.emit('new_message', {
      'sender': '65ca634c40ddbaf5e3db9d01', // Your sender ID
      'content': message,
      'conversation': conversationId // Use dynamic conversationId here
    });
  }

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      // Send the file to the server using the appropriate HTTP request
      String filePath = file.path!;
      String fileName = file.name;

      // Send the file to the server using HTTP POST request
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://10.0.2.2:9090/conversations/$conversationId/attachments'),
        );
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            filePath,
            filename: fileName,
          ),
        );
        var response = await request.send();
        if (response.statusCode == 201) {
          print('File uploaded successfully');
          // Handle success
        } else {
          print('Failed to upload file: ${response.reasonPhrase}');
          // Handle failure
        }
      } catch (e) {
        print('Error uploading file: $e');
        // Handle error
      }
    }
  }

  Color chatBackgroundColor = Colors.white; // Default color for chat background

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D194E),
      body: SafeArea(
        child: Column(
          children: [
            _topChat(),
            _bodyChat(),
            SizedBox(
              height: 120,
            ),
            _formChat(),
          ],
        ),
      ),
    );
  }

  Widget _topChat() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle call action
                    },
                    icon: Icon(
                      Icons.call,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle video call action
                    },
                    icon: Icon(
                      Icons.videocam,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(30),
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      // Replace with actual path
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fiona',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bodyChat() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: chatBackgroundColor, // Use the chat background color here
        ),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return _itemChat(
              chat: message['sender'] == '65ce508521b067df4689e7e8' ? 0 : 1,
              message: message['content'],
              time: message['timestamp'],
            );
          },
        ),
      ),
    );
  }

  _itemChat({chat, avatar, message, time}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        avatar != null
            ? CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(avatar),
              )
            : SizedBox(),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
              borderRadius: chat == 0
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('$message'),
                ),
                IconButton(
                  onPressed: () {
                    // Handle reaction action
                  },
                  icon: Icon(Icons.sentiment_satisfied),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        chat == 1
            ? Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              )
            : SizedBox(),
      ],
    );
  }

  Widget _formChat() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController, // Assign the controller
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: Colors.blueGrey[50],
                labelStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: selectFile, // Call selectFile method to pick a file
            icon: Icon(Icons.attach_file),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              // Handle camera action
            },
            icon: Icon(Icons.camera_alt),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              String message = _textEditingController
                  .text; // Get the message from the text field
              if (message.isNotEmpty) {
                // Check if the message is not empty
                sendMessage(
                    message); // Call sendMessage method with the message
                _textEditingController
                    .clear(); // Clear the text field after sending
              }
            },
            icon: Icon(Icons.send_rounded),
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MessagesScreen(conversationId: '65ce508521b067df4689e7e8'),
  ));
}
