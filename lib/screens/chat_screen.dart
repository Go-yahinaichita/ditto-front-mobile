import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  final String name;
  final String age;
  final String occupation;
  final String experience;
  final String skills;
  final String constraints;
  final String values;
  final String goals;

  const ChatScreen({
    super.key,
    required this.name,
    required this.age,
    required this.occupation,
    required this.experience,
    required this.skills,
    required this.constraints,
    required this.values,
    required this.goals,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final Color mainColor = Color(0xff0e6666);
  bool isLoading = false;
  String currentReply = '';

  @override
  void initState() {
    super.initState();
  }

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello, how are you?',
      'isMine': false,
    },
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        isLoading = true;
        _messages.insert(0, {'text': text, 'isMine': true});
      });
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Show Your AI', style: TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Column(
                      children: [Spacer()],
                    )
                  : ListView.builder(
                      itemCount:
                          _messages.length + (currentReply.isNotEmpty ? 1 : 0),
                      reverse: true,
                      itemBuilder: (content, index) {
                        if (index == 0 && currentReply.isNotEmpty) {
                          return ChatBubble(
                            text: currentReply,
                            isMine: false,
                          );
                        }
                        final message = _messages[
                            index - (currentReply.isNotEmpty ? 1 : 0)];
                        return ChatBubble(
                          text: message['text'] ?? '',
                          isMine: message['isMine'] ?? false,
                        );
                      },
                    ),
            ),
            textInputWidget(),
          ],
        ),
      ),
    );
  }

  SizedBox textInputWidget() {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "メッセージを入力してください",
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                enableSuggestions: true,
                autocorrect: true,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: isLoading ? null : _sendMessage,
              icon: Icon(Icons.send),
              iconSize: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMine;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isMine
            ? EdgeInsets.fromLTRB(50, 5, 10, 0)
            : EdgeInsets.fromLTRB(10, 5, 50, 0),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMine ? Color(0xff0e6666) : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isMine ? Radius.circular(20) : Radius.zero,
            bottomRight: isMine ? Radius.zero : Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isMine ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
