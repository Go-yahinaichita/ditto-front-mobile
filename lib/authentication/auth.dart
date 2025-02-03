import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// uidをバックエンドに送信する関数
Future<void> sendUidToBackend(String uid) async {
  // TODO: バックエンドのエンドポイントを設定
  final url = Uri.parse('https://backend-api.com/endpoint');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'uid': uid,
    })
  );

  if (response.statusCode == 200) {
    // TODO: バックエンドからのレスポンスを処理
    print('UID送信成功');
  } else {
    print('UID送信失敗: ${response.statusCode}');
  }
}

// 新規登録関数
Future<bool> signUp(BuildContext context, TextEditingController emailController,
    TextEditingController passwordController) async {
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

    final User? user = userCredential.user;

    if (user != null) {
      // 新規登録成功時の処理(bodyに付加してバックエンドに送信)
      // TODO: final String uid = user.uid;
      // TODO: await sendUidToBackend(uid);
      return true;
    }
    return false;
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'このメールアドレスは既に登録されています。';
        break;
      case 'invalid-email':
        errorMessage = '無効なメールアドレスです。';
        break;
      case 'weak-password':
        errorMessage = 'パスワードが脆弱すぎます。';
        break;
      case 'operation-not-allowed':
        errorMessage = 'この操作は許可されていません。';
        break;
      default:
        errorMessage = '新規登録に失敗しました: ${e.message}';
    }
    // ユーザーにエラーを表示
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('エラー'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  } catch (e) {
    // 予期しないエラーの詳細を出力
    print('Unexpected Error: $e');


    // 予期しないエラー
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('エラー'),
          content: Text('予期しないエラーが発生しました。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  }
}

// ログイン関数
Future<bool> signIn(BuildContext context, TextEditingController emailController, 
    TextEditingController passwordController) async {
  try {
    final UserCredential userCredential = 
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

    final User? user = userCredential.user;

    if (user != null) {
      // ログイン成功時の処理(bodyに付加してバックエンドに送信)
      // TODO: final String uid = user.uid;
      // TODO: await sendUidToBackend(uid);
      return true;
    }
    return false;
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'このメールアドレスのアカウントは存在しません。';
        break;
      case 'wrong-password':
        errorMessage = 'パスワードが間違っています。';
        break;
      case 'invalid-email':
        errorMessage = '無効なメールアドレスです。';
        break;
      case 'user-disabled':
        errorMessage = 'このアカウントは無効化されています。';
        break;
      case 'too-many-requests':
        errorMessage = '短時間に多くの試行が行われました。しばらくしてから試してください。';
        break;
      default:
        errorMessage = 'ログインに失敗しました: ${e.message}';
    }

    // ユーザーにエラーメッセージを表示
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ログインエラー'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  } catch (e) {
    // 予期しないエラー
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('エラー'),
          content: Text('予期しないエラーが発生しました。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  }
}