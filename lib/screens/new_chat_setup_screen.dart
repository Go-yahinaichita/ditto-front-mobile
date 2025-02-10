import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pjt_ditto_front/provider/user_provider.dart';
import 'package:pjt_ditto_front/screens/chat_screen.dart';

class NewChatSetupScreen extends StatefulWidget {
  static const String id = 'new_chat_setup_screen';

  const NewChatSetupScreen({super.key});

  @override
  NewChatSetupScreenState createState() => NewChatSetupScreenState();
}

class NewChatSetupScreenState extends State<NewChatSetupScreen> {
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _restrictionsController = TextEditingController();
  final TextEditingController _valuesController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();

  final List<String> _ages = [
    ...List.generate(100, (index) => (index).toString())
  ];
  String? _selectedAge = "18";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final String? uid = Provider.of<UserProvider>(context).uid;
    debugPrint("UID: $uid");

    Future<Map<String, dynamic>?> sendUserInfoToServer(String uid) async {
      String apiUrl =
          'https://ditto-back-feature-1025173260301.asia-northeast1.run.app/api/agents/$uid';

      final Map<String, dynamic> userInfo = {
        'age': _selectedAge,
        'status': _statusController.text.trim(),
        'skills': [
          ..._skillsController.text.trim().split(',').map((s) => s.trim()),
          _experienceController.text.trim()
        ], //List
        'values': _valuesController.text.trim(),
        'restrictions': _restrictionsController.text.trim(),
        'future_goals': _goalsController.text
            .trim()
            .split(',')
            .map((s) => s.trim())
            .toList(),
        'extra': "some extra info",
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userInfo),
        );

        debugPrint(
            "Response ${response.body} ${response.statusCode} ${response.request} ${response.headers}");

        if (response.statusCode == 200) {
          debugPrint("ユーザー情報送信成功：${response.body}");
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));

          return responseData;
        } else {
          debugPrint(
              "ユーザー情報送信失敗： ${response.statusCode} ${response.request} ${response.headers}");
          return null;
        }
      } catch (e) {
        debugPrint("エラー: $e");
        return null;
      }
    }

    bool validateForm() {
      return _statusController.text.trim().isNotEmpty &&
          _experienceController.text.trim().isNotEmpty &&
          _skillsController.text.trim().isNotEmpty &&
          _restrictionsController.text.trim().isNotEmpty &&
          _valuesController.text.trim().isNotEmpty &&
          _goalsController.text.trim().isNotEmpty;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "New Chat Setup",
          style: TextStyle(
            color: Color(0xff0a4d4d),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('将来の夢',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              _buildTextField("具体的な目標", _goalsController),
              SizedBox(height: 16),
              Text('自分の情報',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              _buildDropdownField(
                value: _selectedAge,
                items: _ages,
                onChanged: (value) => setState(() => _selectedAge = value),
              ),
              SizedBox(height: 16),
              _buildTextField("現在の立場・職業", _statusController),
              _buildTextField("経験", _experienceController),
              _buildTextField("スキル・資格", _skillsController),
              _buildTextField(
                  "目標を達成する上での制約 (経済面・環境面)", _restrictionsController),
              _buildTextField("大切にしている価値観", _valuesController),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5.0,
                  color: Color(0xff0e6666),
                  borderRadius: BorderRadius.circular(5),
                  child: MaterialButton(
                    onPressed: () async {
                      if (uid == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("ログインしてください。")),
                        );
                        return;
                      }

                      if (!validateForm()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("すべての項目を入力してください。")),
                        );
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      final chatData = await sendUserInfoToServer(uid);
                      debugPrint("Success $chatData");

                      if (chatData != null && context.mounted) {
                        Navigator.pushNamed(
                          context,
                          ChatScreen.id,
                          arguments: chatData,
                        );
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("チャットの作成に失敗しました。")),
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3),
                          )
                        : Text(
                            'Let\'s Chat！',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownMenu<String>(
      initialSelection: value,
      onSelected: onChanged,
      width: double.infinity,
      label: Text("年齢"),
      dropdownMenuEntries: items.map((item) {
        return DropdownMenuEntry<String>(
          value: item,
          label: item,
        );
      }).toList(),
      menuHeight: 200,
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white), // 背景色を白に設定
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff0a4d4d), width: 2),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: null,
        cursorColor: Color(0xff0a4d4d),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff0a4d4d), width: 2),
          ),
        ),
      ),
    );
  }
}
