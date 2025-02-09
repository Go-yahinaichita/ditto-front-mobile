import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pjt_ditto_front/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
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
  final Color mainColor = Color(0xff0e6666);
  bool _isLoading = true;
  String? uid;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      setState(() {
        uid = Provider.of<UserProvider>(context, listen: false).uid;
      });
      if (uid != null) {
        _fetchChatHistory();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchChatHistory() async {
    if (uid == null) return;

    String apiUrl =
        "https://ditto-back-develop-1025173260301.asia-northeast1.run.app/api/agents/$uid";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          chatHistory = data
              .map((chat) => {
                    'id': chat['id'] ?? 0,
                    'title': chat['title'] ?? "No title",
                    'created_at': chat['created_at'] ?? "xx/xx",
                    'updated_at': chat['updated_at'] ?? "xx:xx",
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "History",
          style: const TextStyle(
            color: Color(0xff0A4D4D),
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
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      final chat = chatHistory[index];
                      return ListTile(
                        tileColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                        ),
                        title: Text(chat['title']!,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                DateFormat('MM/dd').format(
                                    DateTime.parse(chat['updated_at']!)),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            Text(
                                DateFormat('HH:mm').format(
                                    DateTime.parse(chat['updated_at']!)),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, ChatScreen.id,
                              arguments: {
                                'id': chat['id'],
                                'title': chat['title'],
                                'created_at': chat['created_at'],
                                'updated_at': chat['updated_at']
                              });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.grey[200],
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
