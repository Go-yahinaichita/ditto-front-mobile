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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                CustomTextField(
                    controller: _emailController, hintText: 'Enter your email'),
                SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  obscureText: true,
                ),
                SizedBox(
                  height: 24,
                ),
                PrimaryButton(
                  text: 'ログイン',
                  onPressed: () async {
                    SignInResult result = await signIn(
                        context, _emailController, _passwordController);
                    if (result.success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      final User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoryScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
                SecondaryButton(
                  text: '新規登録',
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.id);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
