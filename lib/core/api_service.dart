import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:3000/api";
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2:3000/api";
    }

    return "http://localhost:3000/api";
  }

  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<List> getTasks() async {
    final response = await http.get(Uri.parse("$baseUrl/tasks"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }
}
