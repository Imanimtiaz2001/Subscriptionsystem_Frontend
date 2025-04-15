// auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

class AuthProvider extends ChangeNotifier {

  // Login method
  Future<String> login(String email, String password) async {
    final url = Uri.parse('http://192.168.100.65:5000/login'); // Replace with your actual backend URL
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        // If login is successful, extract tokens and handle further
        String accessToken = responseBody['access_token'];
        String refreshToken = responseBody['refresh_token'];

        // Save tokens or use them as per your requirements
        return accessToken;  // You can handle token saving here
      } else {
        return responseBody['msg'];  // Return the error message from backend
      }
    } catch (error) {
      return 'Error: $error';  // Return error if request fails
    }
  }
  // Register method (from previous implementation)
  Future<String> register(String email, String password, String confirmPassword) async {
    final url = Uri.parse('http://192.168.100.65:5000/register'); // Replace with your actual backend URL
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,  // As per your backend, both password and confirm_password are needed
        }),
      );
      final responseBody = json.decode(response.body);
      return responseBody['msg']; // Return the message from backend
    } catch (error) {
      return 'Error: $error'; // Return error if request fails
    }
  }
  Future<dynamic> getProfileData(String accessToken) async {
    final url = Uri.parse('http://192.168.100.65:5000/profile');  // Replace with the actual backend URL
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Log the raw response body for debugging
      print('Response Body: ${response.body}');  // Log the response body

      // Check if the response status is 200 (OK)
      if (response.statusCode == 200) {
        // Check if the response is HTML by looking for the <html> tag
        if (response.body.contains('<html>')) {
          return 'Error: Unexpected HTML response (likely a login or error page)';
        }

        try {
          final responseBody = json.decode(response.body);

          // Return the profile data if JSON is valid
          return responseBody; // Return the profile data as a Map<String, dynamic>
        } catch (e) {
          return 'Error: Invalid JSON response';
        }
      } else {
        return 'Error fetching profile data: ${response.statusCode}';
      }
    } catch (error) {
      return 'Error: $error';
    }
  }

  // Logout function
  Future<void> logoutUser(String accessToken, BuildContext context) async {
    final url = Uri.parse('http://192.168.100.65:5000/logout'); // Backend URL
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),  // Redirect to login page
        );
      } else {
        print('Failed to logout: ${response.body}');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Subscribe function
  Future<void> subscribeToPlan(BuildContext context, String planType, String accessToken) async {
    final url = Uri.parse('http://192.168.100.65:5000/subscribe'); // Backend URL
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'plan_type': planType}),
      );
      final responseBody = json.decode(response.body);
      final message = responseBody['msg'] ?? 'An unexpected error occurred.';
      _showDialogBox(context, message);  // Show dialog box with message
    } catch (error) {
      _showDialogBox(context, 'Error: $error');
    }
  }

  // Helper function to display dialog box
  Future<void> _showDialogBox(BuildContext context, String message) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
// Function to fetch expired subscriptions
  Future<List<dynamic>> fetchExpiredSubscriptions(String accessToken) async {
    final url = Uri.parse('http://192.168.100.65:5000/admin');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response and return the data
      return json.decode(response.body)['expired_subscriptions'];
    } else {
      // Handle error, return empty list or throw error
      throw Exception('Failed to load expired subscriptions');
    }
  }
  Future<void> updateProfile(String accessToken, Map<String, String> data) async {
    final url = Uri.parse('http://192.168.100.65:5000/update-profile');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile: ${response.statusCode}');
        final responseBody = response.body;
        print(responseBody);
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
