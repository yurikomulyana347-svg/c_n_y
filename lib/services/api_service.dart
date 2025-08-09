import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = "http://103.160.63.165/api";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String studentNumber,
    required String major,
    required int classYear,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'student_number': studentNumber,
        'major': major,
        'class_year': classYear,
        'password': password,
        'password_confirmation': password,
      }),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> login({
    required String studentNumber,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'student_number': studentNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['data']['token']);
      }
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<dynamic>> getEvents() async {
    final response = await http.get(Uri.parse('$_baseUrl/events'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<Map<String, dynamic>> createEvent({
    required String title,
    required String description,
    required String startDate,
    required String location,
    required String category,
  }) async {
    final String? token = await _getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/events'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': title,
        'description': description,
        'start_date': startDate,
        'end_date': startDate,
        'location': location,
        'max_attendees': 50,
        'price': 0,
        'category': category,
        'image_url': 'https://via.placeholder.com/150'
      }),
    );
    return json.decode(response.body);
  }
}