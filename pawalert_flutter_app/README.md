# PawAlert Flutter App

Kayıp evcil hayvanları takip etmek için Flutter mobil uygulaması.

## 🌐 Backend URL

Production: `https://pawalert-backend-new.onrender.com`

## ✨ Özellikler

- ✅ Kayıp ilanlarını listeleme
- ✅ İlan detaylarını görüntüleme
- ✅ Kullanıcı kayıt/giriş (JWT authentication)
- ✅ Yeni ilan oluşturma
- ✅ Görülme bildirimi ekleme
- ✅ İlan durumu güncelleme (Kayıp/Bulundu)

## 🚀 Kurulum ve Çalıştırma

```bash
# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

## 📱 Kullanım Örnekleri

### API Servisi Kullanımı

```dart
import 'api_service.dart';

final apiService = ApiService();

// Kullanıcı girişi
final loginResult = await apiService.login(
  email: 'test@example.com',
  password: 'password123',
);
print('Token: ${loginResult['token']}');

// İlanları listele
final reports = await apiService.getReports();
for (var report in reports) {
  print('${report['pet_name']} - ${report['last_seen_location']}');
}

// Yeni ilan oluştur (giriş gerekli)
final newReport = await apiService.createReport(
  petName: 'Pamuk',
  petType: 'Kedi',
  color: 'Beyaz',
  description: 'Sevimli beyaz kedi',
  lastSeenLocation: 'Kadıköy Moda',
);
```

## 📁 Proje Yapısı

```
lib/
├── config.dart         # API URL ve endpoint konfigürasyonu
├── api_service.dart    # Backend API entegrasyonu
└── main.dart          # Ana uygulama ve UI
```

## 🔌 API Endpoints

| Method | Endpoint | Açıklama | Auth |
|--------|----------|----------|------|
| POST | `/auth/register` | Kullanıcı kaydı | ❌ |
| POST | `/auth/login` | Kullanıcı girişi | ❌ |
| GET | `/reports` | Tüm ilanları listele | ❌ |
| GET | `/reports/:id` | İlan detayı | ❌ |
| POST | `/reports` | Yeni ilan oluştur | ✅ |
| PATCH | `/reports/:id/status` | Durum güncelle | ✅ |
| POST | `/reports/:id/seen` | Görülme ekle | ✅ |

## ⚠️ Notlar

- Backend ilk istekte 50 saniye kadar uyuyabilir (Render free tier)
- Token otomatik olarak `ApiService` içinde saklanır
- Logout için `apiService.logout()` kullan
