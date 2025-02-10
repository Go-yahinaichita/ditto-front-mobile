import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pjt_ditto_front/provider/user_provider.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:pjt_ditto_front/screens/login_screen.dart';
import 'package:pjt_ditto_front/screens/register_screen.dart';
import 'package:pjt_ditto_front/screens/welcome_screen.dart';
import 'package:pjt_ditto_front/screens/chat_screen.dart';
import 'package:pjt_ditto_front/screens/history_screen.dart';
import 'package:pjt_ditto_front/screens/new_chat_setup_screen.dart';
import 'package:pjt_ditto_front/screens/change_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter のバインディングを初期化
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase を初期化
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider()..fetchUid(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Show Your AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: WelcomeScreen.id,
      onGenerateRoute: (settings) {
        // final userProvider = Provider.of<UserProvider>(context, listen: false);
        // final String uid = userProvider.uid ?? "";
        switch (settings.name) {
          case WelcomeScreen.id:
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
          case LoginScreen.id:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case RegisterScreen.id:
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case HistoryScreen.id:
            return MaterialPageRoute(builder: (_) => HistoryScreen());
          case NewChatSetupScreen.id:
            return MaterialPageRoute(
                builder: (_) => const NewChatSetupScreen());
          case ChangePasswordScreen.id:
            return MaterialPageRoute(
                builder: (_) => const ChangePasswordScreen());
          case ChatScreen.id:
            if (settings.arguments is Map<String, dynamic>) {
              final chatData = settings.arguments as Map<String, dynamic>;

              Uint8List? iconBytes;
              if (chatData['icon'] is String) {
                iconBytes = base64Decode(chatData['icon'] as String);
              } else if (chatData['icon'] is Uint8List) {
                iconBytes = chatData['icon'] as Uint8List;
              }

              return MaterialPageRoute(
                builder: (_) => ChatScreen(
                  chatId: chatData['id'] ?? 0,
                  title: chatData['title'] ?? "No title",
                  createdAt: DateTime.tryParse(chatData['created_at'] ?? "") ??
                      DateTime.now(),
                  icon: iconBytes,
                ),
              );
            } else {
              return MaterialPageRoute(builder: (_) => const WelcomeScreen());
            }
          default:
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
        }
      },
      locale: const Locale('ja'),
      supportedLocales: const [
        Locale('ja'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
