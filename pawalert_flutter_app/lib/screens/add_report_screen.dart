import 'package:flutter/material.dart';
import '../api_service.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _colorController = TextEditingController();

  String _petType = 'Kedi';
  bool _isLoading = false;

  @override
  void dispose() {
    _petNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();
      await apiService.createReport(
        petName: _petNameController.text,
        petType: _petType,
        color: _colorController.text,
        description: _descriptionController.text,
        lastSeenLocation: _locationController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İlan başarıyla oluşturuldu!')),
        );
        Navigator.pop(context, true); // Return true to refresh the list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıp İlanı Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _petNameController,
                decoration: const InputDecoration(
                  labelText: 'Evcil Hayvan Adı',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen hayvan adını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _petType,
                decoration: const InputDecoration(
                  labelText: 'Hayvan Türü',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'Kedi', child: Text('Kedi')),
                  DropdownMenuItem(value: 'Köpek', child: Text('Köpek')),
                  DropdownMenuItem(value: 'Kuş', child: Text('Kuş')),
                  DropdownMenuItem(value: 'Diğer', child: Text('Diğer')),
                ],
                onChanged: (value) {
                  setState(() => _petType = value!);
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Renk',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.palette),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen renk girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Son Görüldüğü Yer',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen konum girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen açıklama girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'İlan Oluştur',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
