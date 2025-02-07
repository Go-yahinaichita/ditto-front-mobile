import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pjt_ditto_front/provider/user_provider.dart';
import 'package:pjt_ditto_front/screens/chat_screen.dart';

class NewChatSetupScreen extends StatefulWidget {
  static const String id = 'new_chat_setup_screen';

  // final String name;
  // final String age;
  // final String occupation;
  // final String experience;
  // final String skills;
  // final String constraints;
  // final String values;
  // final String goals;

  const NewChatSetupScreen({
    super.key,
    // required this.name,
    // required this.age,
    // required this.occupation,
    // required this.experience,
    // required this.skills,
    // required this.constraints,
    // required this.values,
    // required this.goals,
  });

  @override
  NewChatSetupScreenState createState() => NewChatSetupScreenState();
}

class NewChatSetupScreenState extends State<NewChatSetupScreen> {
  // final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _restrictionsController = TextEditingController();
  final TextEditingController _valuesController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String? uid = Provider.of<UserProvider>(context).uid;
    debugPrint("UID: $uid");

    Future<bool> sendUserInfoToServer(String uid) async {
      String apiUrl =
          'https://ditto-back-develop-1025173260301.asia-northeast1.run.app/api/agents/$uid';

      final Map<String, dynamic> userInfo = {
        // 'name': _nameController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()) ?? 20,
        'status': _statusController.text.trim(),
        'skills': _skillsController.text
            .trim()
            .split(',')
            .map((s) => s.trim())
            .toList(), //List
        'values': _valuesController.text.trim(),
        'restrictions': _restrictionsController.text.trim(),
        'future_goals': _goalsController.text
            .trim()
            .split(',')
            .map((s) => s.trim())
            .toList(),
        'experience': _experienceController.text.trim(),
        'extra': "some extra info",
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userInfo),
        );

        debugPrint("Response ${response.body}");

        if (response.statusCode == 200) {
          debugPrint("ユーザー情報送信成功：${response.body}");
          return true;
        } else {
          debugPrint("ユーザー情報送信失敗： ${response.statusCode}");
          return false;
        }
      } catch (e) {
        debugPrint("エラー: $e");
        return false;
      }
    }

    bool validateForm() {
      return
          // _nameController.text.trim().isNotEmpty &&
          _ageController.text.trim().isNotEmpty &&
              _statusController.text.trim().isNotEmpty &&
              _experienceController.text.trim().isNotEmpty &&
              _skillsController.text.trim().isNotEmpty &&
              _restrictionsController.text.trim().isNotEmpty &&
              _valuesController.text.trim().isNotEmpty &&
              _goalsController.text.trim().isNotEmpty;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Chat Setup",
          style: TextStyle(
            color: Color(0xff0e6666),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // _buildTextField("名前", _nameController),
            _buildTextField("年齢", _ageController,
                keyboardType: TextInputType.number),
            _buildTextField("現在の立場・職業", _statusController),
            _buildTextField("経験", _experienceController),
            _buildTextField("スキル・資格", _skillsController),
            _buildTextField("制約 (経済面・環境面)", _restrictionsController),
            _buildTextField("価値観", _valuesController),
            _buildTextField("具体的な目標", _goalsController),
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

                    if (!mounted) return;

                    bool success = await sendUserInfoToServer(uid);
                    debugPrint("Success $success");

                    if (!mounted) return;

                    if (success) {
                      if (!mounted) return;
                      Navigator.pushNamed(context, ChatScreen.id);
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("チャットの作成に失敗しました。")),
                      );
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Let\'s Chat',
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
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
            borderSide: BorderSide(color: Color(0xff0e6666), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
