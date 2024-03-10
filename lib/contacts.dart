import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'messenger.dart'; // Import MessagesScreen

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<dynamic> conversations = []; // Store fetched conversations
  String currentUserId = '65ca634c40ddbaf5e3db9d01';

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:9090/conversation/$currentUserId'));
    if (response.statusCode == 200) {
      setState(() {
        conversations = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D194E),
      body: SafeArea(
        child: Column(
          children: [
            // Your top section widget remains unchanged
            _top(),
            // Display conversations dynamically
            Expanded(
              child: ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  final lastMessage = conversation['messages'].isEmpty
                      ? {'content': '', 'timestamp': ''}
                      : conversation['messages'].last;
                  final senderName = lastMessage['sender']['name'];
                  final messageContent = lastMessage['content'];
                  final messageTimestamp = lastMessage['timestamp'];

                  return _itemChats(
                    name: senderName,
                    chat: messageContent,
                    time: messageTimestamp,
                    onTap: () {
                      // Navigate to MessagesScreen with conversation ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagesScreen(
                            conversationId: conversation['_id'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your existing top section widget
  Widget _top() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cross Chat with your friends',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Container(
                  height: 100,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      // Replace this with your avatar widget
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.blue,
                        margin: EdgeInsets.only(right: 15),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
              height: 10), // Add some space below the Row to prevent overflow
          Divider(
            color: Colors.white,
            thickness: 1,
            height: 20,
          ),
        ],
      ),
    );
  }

  // Your existing item chat widget
  Widget _itemChats({
    required String name,
    required String chat,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20),
        elevation: 0,
        child: Row(
          children: [
            // Replace this with your avatar widget
            Container(
              width: 60,
              height: 60,
              color: Colors.blue,
              margin: EdgeInsets.only(right: 20),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$name',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$time',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$chat',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatsScreen(),
  ));
}
