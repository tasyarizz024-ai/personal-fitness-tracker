# Personal Fitness Tracker

Aplikasi pencatat aktivitas kebugaran pribadi (Flutter, Android & Web Preview).

## Tim & Pembagian File
| Anggota | Peran | File |
| --- | --- | --- |
| Tasya (Admin) | Data Models, Logic, Git Master | lib/models/, lib/main.dart |
| Jes | UI Form & Kalkulator BMI | lib/screens/add_activity_screen.dart, lib/screens/bmi_screen.dart |
| Bila | UI Nutrition | lib/screens/food_recommendation_screen.dart, lib/widgets/food_card.dart |
| Rendi | UI Dashboard & History | lib/screens/home_screen.dart, lib/widgets/activity_list_item.dart |
| Ahmad | Storage & QA | lib/services/storage_service.dart, test/ |

## Alur Kerja Git
1. git clone <link_repo>
2. Sebelum coding: git pull origin main
3. Setelah selesai: git add . -> git commit -m "pesan" -> git pull origin main -> git push origin main

## Menjalankan
flutter pub get
flutter run -d chrome
