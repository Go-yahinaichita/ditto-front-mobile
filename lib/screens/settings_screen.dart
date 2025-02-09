import 'package:flutter/material.dart';
import 'package:pjt_ditto_front/authentication/auth.dart';
import 'package:pjt_ditto_front/screens/welcome_screen.dart';
import 'package:pjt_ditto_front/screens/change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';

  const SettingsScreen({super.key});
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final Color mainColor = Color(0xff0e6666);
  static const String id = 'settings_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [
                TextButton(
                  child: Text(
                    "パスワード変更",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    // パスワード変更処理
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen(),
                        fullscreenDialog: true
                      )
                    );
                  }
                ),
                TextButton(
                  child: Text(
                    "ログアウト",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    // ログアウト処理
                    AuthResult result = await signOut();
                    if (result.success && context.mounted) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }
}