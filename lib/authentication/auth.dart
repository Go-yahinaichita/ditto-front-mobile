import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pjt_ditto_front/services/api_service.dart';

class AuthResult {
  final bool success;
  final String message;

  AuthResult({required this.success, required this.message});
}

// 新規登録関数
Future<AuthResult> signUp(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController) async {
  try {
    // メールアドレスとパスワードのnullチェック
    if (emailController.text.isEmpty) {
      return AuthResult(success: false, message: 'メールアドレスを入力してください。');
    } else if (passwordController.text.isEmpty) {
      return AuthResult(success: false, message: 'パスワードを入力してください。');
    }

    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final User? user = userCredential.user;

    if (user != null) {
      // 新規登録成功時の処理(bodyに付加してバックエンドに送信)
      await user.sendEmailVerification();
      return AuthResult(success: true, message: '確認メールを送信しました');
      // final String uid = user.uid;
      // if(await sendUidToBackend(uid)) {
      //   return SignUpResult(success: true, message: '登録が完了しました');
      // }
      // return SignUpResult(success: false, message: 'データの送信に失敗しました');
    }
    return AuthResult(success: false, message: '登録に失敗しました');
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
    return AuthResult(success: false, message: errorMessage);
  } catch (e) {
    // 予期しないエラー
    return AuthResult(
        success: false, message: '予期しないエラーが発生しました。 error code: $e');
  }
}

// ログイン関数
Future<AuthResult> signIn(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController) async {
  try {
    // メールアドレスとパスワードのnullチェック
    if (emailController.text.isEmpty) {
      return AuthResult(success: false, message: 'メールアドレスを入力してください。');
    } else if (passwordController.text.isEmpty) {
      return AuthResult(success: false, message: 'パスワードを入力してください。');
    }

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final User? user = userCredential.user;

    if (user != null && user.emailVerified) {
      return AuthResult(success: true, message: 'ログインしました');
    }
    return AuthResult(success: false, message: 'メールアドレスが確認されていません');
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
    return AuthResult(success: false, message: errorMessage);
  } catch (e) {
    // 予期しないエラー
    return AuthResult(
        success: false, message: '予期しないエラーが発生しました。 error code: $e');
  }
}

// ログアウト関数
Future<AuthResult> signOut() async {
  await FirebaseAuth.instance.signOut();
  if (FirebaseAuth.instance.currentUser == null) {
    return AuthResult(success: true, message: 'ログアウトしました');
  }
  return AuthResult(success: false, message: 'ログアウトに失敗しました');
}

// パスワードリセット関数
Future<String> resetPassword(
    BuildContext context, TextEditingController emailController) async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
    return 'パスワードリセットメールを送信しました';
  } catch (e) {
    return 'パスワードリセットに失敗しました: $e';
  }
}

// パスワード変更関数
Future<AuthResult> updatePassword(
    BuildContext context, TextEditingController passwordController) async {
  try {
    await FirebaseAuth.instance.currentUser
        ?.updatePassword(passwordController.text.trim());
    return AuthResult(success: true, message: 'パスワードを変更しました');
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    switch (e.code) {
      case 'weak-password':
        errorMessage = 'パスワードが脆弱すぎます。';
        break;
      case 'requires-recent-login':
        errorMessage = '再ログインが必要です。';
        break;
      default:
        errorMessage = 'パスワード変更に失敗しました: ${e.message}';
    }
    return AuthResult(success: false, message: errorMessage);
  } catch (e) {
    return AuthResult(
        success: false, message: '予期しないエラーが発生しました。 error code: $e');
  }
}
