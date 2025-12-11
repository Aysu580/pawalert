import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(const PawAlertApp());
}

class PawAlertApp extends StatelessWidget {
  const PawAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawAlert',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<dynamic> _reports = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final reports = await _apiService.getReports();
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawAlert - Kayıp Evcil Hayvanlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReports,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to login/register
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login ekranı eklenecek')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Hata: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadReports,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (_reports.isEmpty) {
      return const Center(
        child: Text('Henüz kayıp ilan yok'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReports,
      child: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(report['pet_name'][0].toUpperCase()),
              ),
              title: Text(report['pet_name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tür: ${report['pet_type'] ?? 'Belirtilmemiş'}'),
                  Text('Son görülme: ${report['last_seen_location']}'),
                  Text('Durum: ${report['status'] == 'active' ? 'Kayıp' : 'Bulundu'}'),
                ],
              ),
              trailing: Icon(
                report['status'] == 'active'
                    ? Icons.search
                    : Icons.check_circle,
                color: report['status'] == 'active'
                    ? Colors.orange
                    : Colors.green,
              ),
              onTap: () {
                // TODO: Show report details
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(report['pet_name']),
                    content: Text(report['description'] ?? 'Açıklama yok'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Kapat'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
