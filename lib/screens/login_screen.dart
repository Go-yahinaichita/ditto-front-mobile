import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../authentication/auth.dart';
import 'package:pjt_ditto_front/screens/register_screen.dart';
import 'package:pjt_ditto_front/screens/history_screen.dart';
import 'package:pjt_ditto_front/components/custom_text_field.dart';
import 'package:pjt_ditto_front/components/primary_button.dart';
import 'package:pjt_ditto_front/components/secondary_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final Color mainColor = Color(0xff0e6666);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _forgotPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.microtask(() {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'ログイン',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (!_forgotPassword) ...[
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  autofocus: true,
                ),
                SizedBox(
                  height: 8,
                ),
                CustomTextField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    obscureText: true),
                SizedBox(
                  height: 24,
                ),
                PrimaryButton(
                  text: 'ログイン',
                  color: mainColor,
                  onPressed: () async {
                    AuthResult result = await signIn(
                        context, _emailController, _passwordController);
                    if (result.success && context.mounted) {
                      // context.mountedをチェック
                      // ログイン完了メッセージを表示a
                      setState(() {
                        isLoading = true;
                      });
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
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      // ログイン失敗メッセージを表示
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });

                    if (result.success) {
                      final User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HistoryScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    }
                  },
                ),
                SecondaryButton(
                  text: "新規登録",
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.id);
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        child: Text(
                          "パスワードを忘れた方はこちら",
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _forgotPassword = true;
                          });
                        }),
                  ),
                ),
              ] else ...[
                Text(
                  '登録済みのメールアドレスを入力してください',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  autofocus: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    elevation: 5.0,
                    color: mainColor,
                    borderRadius: BorderRadius.circular(5),
                    child: MaterialButton(
                      onPressed: () async {
                        // パスワードリセット処理
                        String result =
                            await resetPassword(context, _emailController);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'パスワードリセット',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: TextButton(
                    child: Text(
                      "戻る",
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _forgotPassword = false;
                      });
                    },
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
