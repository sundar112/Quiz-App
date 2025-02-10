import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:5000"; // Change to your actual backend URL

  // ✅ Login Function
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      // ✅ Save Token for Future API Calls
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);
      await prefs.setString("userId", data['userId']);
      await prefs.setString("role", data['role']); // Storing user role if needed

      return true;
    } else {
      return false;
    }
  }

  // ✅ Register Function
  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "email": email, "password": password}),
    );

    return response.statusCode == 201;
  }

  // ✅ Logout Function (Clears Token)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("userId");
    await prefs.remove("role");
  }

  // ✅ Get Authenticated User
  Future<Map<String, dynamic>?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/user"),
      headers: {"Authorization": token},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}


// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   final String baseUrl = "http://10.0.2.2:5000"; // ✅ Use "10.0.2.2" for Android Emulator

//   Future<bool> login(String email, String password) async {
//     try {
//       print("🔄 Sending Login Request...");
//       final response = await http.post(
//         Uri.parse("$baseUrl/login"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": email, "password": password}),
//       );

//       print("🔍 Response Status Code: ${response.statusCode}");
//       print("🔍 Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         String token = data['token'];

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString("token", token);
//         await prefs.setString("userId", data['userId']);

//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       print("❌ Login Error: $e");
//       return false;
//     }
//   }

//   Future<bool> register(String username, String email, String password) async {
//     try {
//       print("🔄 Sending Register Request...");
//       final response = await http.post(
//         Uri.parse("$baseUrl/register"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"username": username, "email": email, "password": password}),
//       );

//       print("🔍 Response Status Code: ${response.statusCode}");
//       print("🔍 Response Body: ${response.body}");

//       return response.statusCode == 201;
//     } catch (e) {
//       print("❌ Register Error: $e");
//       return false;
//     }
//   }
// }
