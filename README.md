# Personal Fitness Tracker App

Aplikasi pencatat aktivitas kebugaran pribadi berbasis Android untuk melacak konsistensi olahraga, menghitung estimasi kalori terbakar, serta memberikan panduan nutrisi pasca-olahraga secara praktis.

## 🛠️ Spesifikasi Teknis

- **Bahasa Pemrograman:** Dart
- **Framework:** Flutter
- **Target Platform:** Android (Pengembangan & _Preview_ menggunakan Google Chrome)
- **Penyimpanan Data:** `shared_preferences` (Local Storage offline)
- **Version Control:** Git & GitHub

## 👥 Susunan Tim & Pembagian Tugas

Pengembangan dilakukan secara _remote_ dengan pembagian file yang terisolasi untuk mencegah _merge conflict_.

| Nama Anggota      | Peran / Modul Utama              | Fokus File di Flutter                                                    |
| :---------------- | :------------------------------- | :----------------------------------------------------------------------- |
| **Tasya** (Admin) | Data Models, Logic, & Git Master | `lib/models/` (Class aktivitas & makanan), Manajemen Repo.               |
| **Jes**           | UI Forms & Kalkulator BMI        | `lib/screens/add_activity_screen.dart` & `lib/screens/bmi_screen.dart`.  |
| **Bila**          | UI Nutrition                     | `lib/screens/food_recommendation_screen.dart` & komponen kartu.          |
| **Rendi**         | UI Dashboard & History           | `lib/screens/home_screen.dart` & daftar riwayat (_ListView_).            |
| **Ahmad**         | Storage & QA Testing             | `lib/services/storage_service.dart` (implementasi `shared_preferences`). |

## ✨ Rincian Fitur Aplikasi

1. **Dashboard Ringkasan Harian:** Menampilkan ringkasan total durasi olahraga, estimasi kalori harian, dan daftar riwayat aktivitas.
2. **Pencatatan Aktivitas & Kalkulator Kalori:** Form input jenis olahraga (dropdown) dan durasi (menit), dilengkapi logika penghitungan otomatis berdasarkan jenis aktivitas.
3. **Saran Makanan Pasca-Olahraga:** Menampilkan rekomendasi asupan (tinggi protein/karbohidrat untuk > 300 kkal, hidrasi ringan untuk < 300 kkal) dalam bentuk _Card_ setelah olahraga disimpan.
4. **Kalkulator BMI:** Halaman penghitung indeks massa tubuh berdasarkan berat (kg) dan tinggi badan (cm) beserta status kategorinya.
5. **Data Persistence:** Penyimpanan data riwayat aktivitas secara lokal di memori perangkat menggunakan package `shared_preferences`.

## 🚀 Panduan Git & Alur Kerja Kelompok

**1. Mengambil Project (Clone - Hanya dilakukan sekali di awal oleh anggota tim)**

```bash
git clone [https://github.com/tasyarizz024-ai/personal-fitness-tracker.git](https://github.com/tasyarizz024-ai/personal-fitness-tracker.git)
```
