import 'package:flutter/material.dart';
import 'package:pjt_ditto_front/screens/chat_screen.dart';

class NewChatSetupScreen extends StatefulWidget {
  static const String id = 'new_chat_setup_screen';

  const NewChatSetupScreen({super.key});

  @override
  NewChatSetupScreenState createState() => NewChatSetupScreenState();
}

class NewChatSetupScreenState extends State<NewChatSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _constraintsController = TextEditingController();
  final TextEditingController _valuesController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            _buildTextField("名前", _nameController),
            _buildTextField("年齢", _ageController,
                keyboardType: TextInputType.number),
            _buildTextField("現在の立場・職業", _occupationController),
            _buildTextField("経験", _experienceController),
            _buildTextField("スキル・資格", _skillsController),
            _buildTextField("制約 (経済面・環境面)", _constraintsController),
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
                    Navigator.pushNamed(
                      context,
                      ChatScreen.id,
                      arguments: {
                        'name': _nameController.text,
                        'age': _ageController.text,
                        'occupation': _occupationController.text,
                        'experience': _experienceController.text,
                        'skills': _skillsController.text,
                        'constraints': _constraintsController.text,
                        'values': _valuesController.text,
                        'goals': _goalsController.text,
                      },
                    );
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
