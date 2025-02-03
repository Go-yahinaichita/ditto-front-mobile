import 'package:flutter/material.dart';
import 'package:pjt_ditto_front/screens/register_screen.dart';
import 'package:pjt_ditto_front/screens/history_screen.dart';
import '../authentication/auth.dart';

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
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                autofocus: true,
                controller: _emailController,
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                controller: _passwordController,
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5.0,
                  color: mainColor,
                  borderRadius: BorderRadius.circular(5),
                  child: MaterialButton(
                    onPressed: () async {
                      bool isSuccess = await signIn(context, _emailController, _passwordController);
                      if (isSuccess && context.mounted) { // context.mountedをチェック
                        // ログイン完了メッセージを表示
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ログインしました'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        Navigator.pushNamed(context, HistoryScreen.id);
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'ログイン',
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
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5.0,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      '新規登録',
                      style: TextStyle(
                        color: mainColor,
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
}
