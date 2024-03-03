import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<MessagesScreen> {
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
                      backgroundImage: AssetImage('assets/image/5.jpg'), // Replace with actual path
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
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            _itemChat(
              avatar: 'assets/image/5.jpg',
              chat: 1,
              message:
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              time: '18.00',
            ),
            _itemChat(
              chat: 0,
              message: 'Okey 🐣',
              time: '18.00',
            ),
            _itemChat(
              avatar: 'assets/image/5.jpg',
              chat: 1,
              message: 'It has survived not only five centuries, 😀',
              time: '18.00',
            ),
            _itemChat(
              chat: 0,
              message:
                  'Contrary to popular belief, Lorem Ipsum is not simply random text. 😎',
              time: '18.00',
            ),
            _itemChat(
              avatar: 'assets/image/5.jpg',
              chat: 1,
              message:
                  'The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
              time: '18.00',
            ),
            _itemChat(
              avatar: 'assets/image/5.jpg',
              chat: 1,
              message: '😅 😂 🤣',
              time: '18.00',
            ),
          ],
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
            onPressed: () {
              // Handle add file action
            },
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
              // Handle record audio action
            },
            icon: Icon(Icons.mic),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              // Handle send message action
            },
            icon: Icon(Icons.send_rounded),
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
