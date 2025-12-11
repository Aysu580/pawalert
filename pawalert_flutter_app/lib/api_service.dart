import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

/// API Service for PawAlert Backend
class ApiService {
  // Store token after login
  String? _authToken;

  // Get authorization headers
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {'Content-Type': 'application/json'};
    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // ==================== AUTH ====================

  /// Register new user
  /// Returns: {id, name, email}
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.apiBaseUrl}${Config.registerEndpoint}'),
        headers: _getHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  /// Login user
  /// Returns: {token, user: {id, name, email}}
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.apiBaseUrl}${Config.loginEndpoint}'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token']; // Save token
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Logout (clear token)
  void logout() {
    _authToken = null;
  }

  // ==================== REPORTS ====================

  /// Get all missing pet reports
  /// Returns: List of reports
  Future<List<dynamic>> getReports() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.apiBaseUrl}${Config.reportsEndpoint}'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      throw Exception('Get reports error: $e');
    }
  }

  /// Get single report by ID
  /// Returns: {report: {...}, seens: [...]}
  Future<Map<String, dynamic>> getReportById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.apiBaseUrl}${Config.reportsEndpoint}/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Report not found');
      }
    } catch (e) {
      throw Exception('Get report error: $e');
    }
  }

  /// Create new missing pet report (requires auth)
  Future<Map<String, dynamic>> createReport({
    required String petName,
    required String lastSeenLocation,
    String? petType,
    String? color,
    String? description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.apiBaseUrl}${Config.reportsEndpoint}'),
        headers: _getHeaders(includeAuth: true),
        body: jsonEncode({
          'pet_name': petName,
          'last_seen_location': lastSeenLocation,
          'pet_type': petType,
          'color': color,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to create report');
      }
    } catch (e) {
      throw Exception('Create report error: $e');
    }
  }

  /// Update report status (owner only)
  /// Status: 'active' or 'found'
  Future<void> updateReportStatus(int reportId, String status) async {
    if (!['active', 'found'].contains(status)) {
      throw Exception('Invalid status. Use "active" or "found"');
    }

    try {
      final response = await http.patch(
        Uri.parse('${Config.apiBaseUrl}${Config.reportsEndpoint}/$reportId/status'),
        headers: _getHeaders(includeAuth: true),
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to update status');
      }
    } catch (e) {
      throw Exception('Update status error: $e');
    }
  }

  /// Add a sighting to a report (requires auth)
  Future<Map<String, dynamic>> addSighting({
    required int reportId,
    String? note,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.apiBaseUrl}${Config.reportsEndpoint}/$reportId/seen'),
        headers: _getHeaders(includeAuth: true),
        body: jsonEncode({'note': note}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to add sighting');
      }
    } catch (e) {
      throw Exception('Add sighting error: $e');
    }
  }

  // ==================== HELPERS ====================

  /// Check if user is logged in
  bool get isLoggedIn => _authToken != null;

  /// Get current auth token
  String? get authToken => _authToken;
}
