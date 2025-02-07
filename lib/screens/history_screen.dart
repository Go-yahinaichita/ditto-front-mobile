import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pjt_ditto_front/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pjt_ditto_front/screens/new_chat_setup_screen.dart';
import 'package:pjt_ditto_front/screens/welcome_screen.dart';
import 'package:pjt_ditto_front/screens/chat_screen.dart';
import 'package:pjt_ditto_front/screens/settings_screen.dart';

class HistoryScreen extends StatefulWidget {
  static const String id = 'history_screen';

  const HistoryScreen({super.key});
  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> chatHistory = [];

  static const String id = 'history_screen';
  final Color mainColor = Color(0xff0e6666);

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
  }

  Future<void> _fetchChatHistory() async {
    final String? uid = Provider.of<UserProvider>(context, listen: false).uid;
    if (uid == null) {
      debugPrint("No uid");
      return;
    }
    String apiUrl =
        "https://ditto-back-develop-1025173260301.asia-northeast1.run.app/api/agents/conversations/$uid";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          chatHistory = data
              .map((chat) => {
                    'id': chat['id'] ?? 0,
                    'title': chat['title'] ?? "No title",
                    'created_at': chat['created_at'] ?? "xx/xx",
                    'updated_at': chat['updated_at'] ?? "xx:xx",
                  })
              .toList();
        });
      }
    } catch (e) {
      debugPrint("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: TextStyle(
            color: mainColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.add, size: 28, color: Colors.black54),
            ),
            title: const Text(
              "新しいチャットを始める",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, NewChatSetupScreen.id);
            },
          ),
          const Divider(),

          // チャット履歴リスト（スクロール可能）
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: chatHistory.map((chat) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                    ),
                    title: Text(chat['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(chat['subtitle']!),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(chat['created_at']!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54)),
                        Text(chat['updated_at']!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, ChatScreen.id);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home, size: 28),
                onPressed: () {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, NewChatSetupScreen.id);
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("New Chat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, size: 28),
                onPressed: () {
                  Navigator.pushNamed(context, SettingsScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
