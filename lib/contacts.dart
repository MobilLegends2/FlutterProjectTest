import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<dynamic> conversations = []; // Store fetched conversations

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:9090/conversations/'));
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
                  // Parse conversation data and return the corresponding widget
                  return _itemChats(
                    name: conversation['participants']
                        [0], // Assuming participants contain names
                    chat: conversation['messages'][0]
                        ['content'], // Displaying the latest message
                    time: conversation['messages'][0][
                        'timestamp'], // Displaying the timestamp of the latest message
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
                      return Avatar(
                        size: 60,
                        margin: EdgeInsets.only(right: 15),
                        image: '1.jpg',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
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
  Widget _itemChats(
      {required String name, required String chat, required String time}) {
    return GestureDetector(
      onTap: () {
        // Handle chat item tap
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20),
        elevation: 0,
        child: Row(
          children: [
            Avatar(
              margin: EdgeInsets.only(right: 20),
              size: 60,
              image: 'assets/image/placeholder.jpg', // Placeholder image path
              hasBorder: true, // Add border to avatar
              elevation: 2, // Add shadow effect
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

class Avatar extends StatelessWidget {
  final double size;
  final String image;
  final EdgeInsets margin;
  final bool hasBorder;
  final double elevation;

  const Avatar({
    Key? key,
    required this.size,
    required this.image,
    this.margin = EdgeInsets.zero,
    this.hasBorder = false,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
          border: hasBorder
              ? Border.all(
                  color: Colors.white,
                  width: 2.0,
                )
              : null,
          boxShadow: hasBorder
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: elevation,
                    spreadRadius: elevation / 2,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
