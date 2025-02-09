import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  final int chatId;
  final String title;
  final DateTime createdAt;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.title,
    required this.createdAt,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final Color mainColor = Color(0xff0e6666);
  bool _isLoading = true;
  bool _sendingMessage = false;
  String currentReply = '';
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _getChatHistory();
  }

  Future<void> _getChatHistory() async {
    String apiUrl =
        "https://ditto-back-feature-1025173260301.asia-northeast1.run.app/api/agents/conversations/${widget.chatId}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> responseData =
            List<Map<String, dynamic>>.from(
                jsonDecode(utf8.decode(response.bodyBytes)));

        setState(() {
          _messages = responseData.reversed
              .map((message) => {
                    "id": message["id"],
                    "role": message["role"],
                    "message": message["message"],
                    "created_at": message["created_at"],
                  })
              .toList();
          _isLoading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } else {
        debugPrint("履歴取得失敗: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("履歴取得エラー: $e");
    }
  }

  Future<void> _sendMessageToServer(String message) async {
    String apiUrl =
        "https://ditto-back-feature-1025173260301.asia-northeast1.run.app/api/agents/conversations/${widget.chatId}";

    final Map<String, String> messageData = {
      'message': message,
    };

    setState(() {
      _messages.insert(0, {
        "role": "user",
        "message": message,
        "created_at": DateTime.now().toIso8601String(),
      });
    });

    debugPrint("MessageData ${jsonEncode(messageData)}");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(messageData),
      );

      debugPrint("Resopnse ${response.body}");
      debugPrint("Message: $messageData");

      if (response.statusCode == 200) {
        final responseText = response.body;
        setState(() {
          _messages.insert(0, {
            "role": "agent",
            "message": responseText,
            "created_at": DateTime.now().toIso8601String(),
          });

          _sendingMessage = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } else {
        debugPrint(
            "メッセージ送信失敗: $messageData ${response.statusCode} ${response.request} ${response.headers}");
      }
    } catch (e) {
      debugPrint("error: $e");
      setState(() {
        _sendingMessage = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _sendingMessage = true;
      });

      _sendMessageToServer(text);
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
        title: Text(widget.title,
            style: TextStyle(
                color: Color(0xff0a4d4d), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _messages.isEmpty
                      ? const Center(child: Text("メッセージ履歴なし"))
                      : ListView.builder(
                          itemCount: _messages.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            return ChatBubble(
                              text: message['message'] ?? '',
                              isUser: message['role'] == 'user',
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
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                keyboardType: TextInputType.multiline,
                enableSuggestions: true,
                autocorrect: true,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: _sendingMessage ? null : _sendMessage,
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
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isUser
            ? EdgeInsets.fromLTRB(50, 5, 10, 0)
            : EdgeInsets.fromLTRB(10, 5, 50, 0),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Color(0xff0e6666) : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isUser ? Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
