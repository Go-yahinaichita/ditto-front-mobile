import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";

  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final Color mainColor = Color(0xff0e6666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0e6666),
      body: Stack(
        children: [
          // SHOW YOUR AI の背景
          Positioned.fill(
            child: SafeArea(
              child: Align(
                alignment: Alignment.centerLeft,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "SHOW YOUR AI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 125,
                      height: 0.9,
                      fontFamily: "NotoSansJPExtraBold",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "show you your feature",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "NotoSansJPRegular",
                        ),
                      ),
                      const SizedBox(height: 100),
                      const Text(
                        "将来",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: "NotoSerifJPBold",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "将来のあなたと話せます。将来のために何をすればいいかわからない。"
                        "そんなあなたに送る新感覚AIチャットアプリ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "NotoSansJPRegular"),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Color(0xff144952),
                            side: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          child: const Text(
                            'ログイン',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: "NotoSansJPRegular"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterScreen.id);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Color(0xff144952),
                            side: const BorderSide(color: Colors.white),
                          ),
                          child: const Text(
                            '新規登録',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: "NotoSansJPRegular",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
