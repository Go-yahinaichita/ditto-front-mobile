import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// uidをバックエンドに送信する関数
Future<bool> sendUidToBackend(String uid) async {
  // TODO: バックエンドのエンドポイントを設定
  final url = Uri.parse(dotenv.env['BACKEND_API_URL']!);
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
    return true;
  } else {
    print('UID送信失敗: ${response.statusCode}');
    return false;
  }
}
