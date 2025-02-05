import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pjt_ditto_front/services/api_service.dart';

class SignInResult {
  final bool success;
  final String message;

  SignInResult({required this.success, required this.message});
}

class SignUpResult {
  final bool success;
  final String message;

  SignUpResult({required this.success, required this.message});
}

class SignOutResult {
  final bool success;
  final String message;

  SignOutResult({required this.success, required this.message});
}

// 新規登録関数
Future<SignUpResult> signUp(BuildContext context, TextEditingController emailController,
    TextEditingController passwordController) async {
  try {
    // メールアドレスとパスワードのnullチェック
    if (emailController.text.isEmpty) {
      return SignUpResult(success: false, message: 'メールアドレスを入力してください。');
    } else if (passwordController.text.isEmpty) {
      return SignUpResult(success: false, message: 'パスワードを入力してください。');
    }

    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

    final User? user = userCredential.user;

    if (user != null) {
      // 新規登録成功時の処理(bodyに付加してバックエンドに送信)
      final String uid = user.uid;
      if(await sendUidToBackend(uid)) {
        return SignUpResult(success: true, message: '登録が完了しました');
      }
      return SignUpResult(success: false, message: 'データの送信に失敗しました');
    }
    return SignUpResult(success: false, message: '登録に失敗しました');
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
    return SignUpResult(success: false, message: errorMessage);
  } catch (e) {
    // 予期しないエラー
    return SignUpResult(success: false, message: '予期しないエラーが発生しました。 error code: $e');
  }
}

// ログイン関数
Future<SignInResult> signIn(BuildContext context, TextEditingController emailController, 
    TextEditingController passwordController) async {
  try {
    // メールアドレスとパスワードのnullチェック
    if (emailController.text.isEmpty) {
      return SignInResult(success: false, message: 'メールアドレスを入力してください。');
    } else if (passwordController.text.isEmpty) {
      return SignInResult(success: false, message: 'パスワードを入力してください。');
    }

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
      return SignInResult(success: true, message: 'ログインしました');
    }
    return SignInResult(success: false, message: 'ログインに失敗しました');
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
    return SignInResult(success: false, message: errorMessage);
  } catch (e) {
    // 予期しないエラー
    return SignInResult(success: false, message: '予期しないエラーが発生しました。 error code: $e');
  }
}

// ログアウト関数
Future<SignOutResult> signOut() async {
  await FirebaseAuth.instance.signOut();
  if (FirebaseAuth.instance.currentUser == null) {
    return SignOutResult(success: true, message: 'ログアウトしました');
  }
  return SignOutResult(success: false, message: 'ログアウトに失敗しました');
}