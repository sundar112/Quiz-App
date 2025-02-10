import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://192.168.1.180:5000"; // ✅ Use "10.0.2.2" for Android Emulator insted of localhost

  Future<bool> login(String email, String password) async {
    try {
      print("🔄 Sending Login Request...");
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("🔍 Response Status Code: ${response.statusCode}");
      print("🔍 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        await prefs.setString("userId", data['userId']);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Login Error: $e");
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      print("🔄 Sending Register Request...");
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "email": email, "password": password}),
      );

      print("🔍 Response Status Code: ${response.statusCode}");
      print("🔍 Response Body: ${response.body}");

      return response.statusCode == 201;
    } catch (e) {
      print("❌ Register Error: $e");
      return false;
    }
  }
}
