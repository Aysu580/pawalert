# PawAlert Flutter App

Kayıp evcil hayvanları takip etmek için Flutter mobil uygulaması.

## Backend

Backend URL: `https://pawalert-backend-new.onrender.com`

## Özellikler

- ✅ Kayıp ilanlarını listeleme
- ✅ İlan detaylarını görüntüleme
- ✅ Kullanıcı kayıt/giriş
- ✅ Yeni ilan oluşturma
- ✅ Görülme bildirimi ekleme
- ✅ İlan durumu güncelleme (Kayıp/Bulundu)

## Kurulum

```bash
# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

## API Kullanımı

### Örnek: Kullanıcı Girişi

```dart
final apiService = ApiService();

try {
  final result = await apiService.login(
    email: 'test@test.com',
    password: '123456',
  );

  print('Token: ${result['token']}');
  print('User: ${result['user']}');
} catch (e) {
  print('Login hatası: $e');
}
```

### Örnek: İlanları Listeleme

```dart
final reports = await apiService.getReports();
for (var report in reports) {
  print('${report['pet_name']} - ${report['last_seen_location']}');
}
```

### Örnek: Yeni İlan Oluşturma

```dart
// Önce giriş yap
await apiService.login(email: 'user@test.com', password: '123456');

// İlan oluştur
final report = await apiService.createReport(
  petName: 'Pamuk',
  petType: 'Kedi',
  color: 'Beyaz',
  description: 'Mavi gözlü, sevimli bir kedi',
  lastSeenLocation: 'Kadıköy Moda Parkı',
);

print('İlan oluşturuldu: ${report['id']}');
```

## Dosya Yapısı

```
lib/
├── config.dart         # API URL ve endpoint ayarları
├── api_service.dart    # Backend API istekleri
└── main.dart           # Ana uygulama ve UI
```

## API Endpoints

- `POST /auth/register` - Kullanıcı kaydı
- `POST /auth/login` - Giriş
- `GET /reports` - Tüm ilanlar
- `POST /reports` - Yeni ilan (auth)
- `GET /reports/:id` - İlan detayı
- `PATCH /reports/:id/status` - Durum güncelle (auth)
- `POST /reports/:id/seen` - Görülme ekle (auth)

## Notlar

- Backend ilk istekte 50 saniye kadar uyuyabilir (Render free tier)
- Token otomatik olarak ApiService içinde saklanır
- Logout için `apiService.logout()` kullan
