import 'package:flutter/material.dart';
import 'package:pjt_ditto_front/screens/welcome_screen.dart';
import 'package:pjt_ditto_front/screens/chat_screen.dart';

class HistoryScreen extends StatefulWidget {
  static const String id = 'history_screen';

  const HistoryScreen({super.key});
  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  static const String id = 'history_screen';
  final Color mainColor = Color(0xff0e6666);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chatHistory = List.generate(20, (index) {
      return {
        'title': '歯医者',
        'subtitle': '10年後のあなたは...',
        'date': '1/26',
        'time': '12:05'
      };
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(
            color: Color(0xff0e6666),
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
              Navigator.pushNamed(context, ChatScreen.id);
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
                        Text(chat['date']!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54)),
                        Text(chat['time']!,
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
                  Navigator.pushNamed(context, ChatScreen.id);
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
                  // 設定画面へ移動
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
