// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';

class StorageService {
  static const String _sessionUserKey = 'ft_active_username';
  static const String _sessionNameKey = 'ft_active_fullname';
  static const String _accountsKey = 'ft_registered_accounts';

  // -------------------------------------------------------------
  // AUTH & USER SESSION
  // -------------------------------------------------------------

  Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_sessionUserKey);
    final name = prefs.getString(_sessionNameKey);
    if (username == null || username.isEmpty) return null;
    return {'username': username, 'name': name ?? username};
  }

  Future<void> setCurrentUser(String username, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionUserKey, username);
    await prefs.setString(_sessionNameKey, name);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionUserKey);
    await prefs.remove(_sessionNameKey);
  }

  Future<List<Map<String, String>>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_accountsKey);
    if (jsonStr == null) {
      return [];
    }
    final List<dynamic> decoded = jsonDecode(jsonStr);
    return decoded.map((e) => Map<String, String>.from(e as Map)).toList();
  }

  Future<bool> registerAccount(
      String name, String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await getAccounts();
    final cleanUsername =
        username.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');

    if (accounts.any((a) => a['username'] == cleanUsername)) {
      return false; // Already exists
    }

    accounts.add(
        {'username': cleanUsername, 'name': name.trim(), 'password': password});
    await prefs.setString(_accountsKey, jsonEncode(accounts));

    // Ketentuan: Akun baru yang mendaftar TIDAK memunculkan histori sama sekali (kosong)
    await prefs.setStringList('ft_act_$cleanUsername', <String>[]);
    await setCurrentUser(cleanUsername, name.trim());
    return true;
  }

  Future<bool> loginAccount(String identifier, String password) async {
    final accounts = await getAccounts();
    final cleanId =
        identifier.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');

    final found = accounts.firstWhere(
      (a) =>
          a['username'] == cleanId ||
          (a['name'] ?? '').toLowerCase() == identifier.trim().toLowerCase(),
      orElse: () => {},
    );

    if (found.isEmpty) {
      // Akun belum terdaftar, harus daftar terlebih dahulu
      return false;
    }

    if (found['password'] != null &&
        found['password'] != password &&
        password.isNotEmpty) {
      return false; // Wrong password
    }

    await setCurrentUser(found['username']!, found['name']!);
    return true;
  }

  // -------------------------------------------------------------
  // ACTIVITIES PER USER
  // -------------------------------------------------------------

  String _getUserKey(String? username) {
    final u = username ?? 'pengguna_fit';
    return 'ft_act_$u';
  }

  Future<List<Activity>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getCurrentUser();
    final username = user?['username'] ?? 'pengguna_fit';
    final key = _getUserKey(username);

    final List<String>? jsonList = prefs.getStringList(key);

    if (jsonList == null) return [];

    final activities = jsonList
        .map(
            (str) => Activity.fromJson(jsonDecode(str) as Map<String, dynamic>))
        .where((activity) => !RegExp(r'^hist_\d+_\d+$').hasMatch(activity.id))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (activities.length != jsonList.length) {
      await saveActivities(activities);
    }

    return activities;
  }

  Future<void> saveActivities(List<Activity> activities) async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getCurrentUser();
    final username = user?['username'] ?? 'pengguna_fit';
    final key = _getUserKey(username);

    final List<String> jsonList =
        activities.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  Future<void> addActivity(Activity activity) async {
    final activities = await getActivities();
    activities.insert(0, activity);
    await saveActivities(activities);
  }

  Future<void> saveActivity(Activity activity) => addActivity(activity);

  Future<void> deleteActivity(String id) async {
    final activities = await getActivities();
    activities.removeWhere((a) => a.id == id);
    await saveActivities(activities);
  }

  // -------------------------------------------------------------
  // FAVORITE FOODS
  // -------------------------------------------------------------

  Future<List<String>> getFavoriteFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getCurrentUser();
    final username = user?['username'] ?? 'pengguna_fit';
    return prefs.getStringList('ft_fav_$username') ?? ['food_1', 'food_6'];
  }

  Future<void> toggleFavoriteFood(String foodId) async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getCurrentUser();
    final username = user?['username'] ?? 'pengguna_fit';
    final list = await getFavoriteFoods();
    if (list.contains(foodId)) {
      list.remove(foodId);
    } else {
      list.add(foodId);
    }
    await prefs.setStringList('ft_fav_$username', list);
  }

  // -------------------------------------------------------------
  // SAVED FOOD MENUS (full item data)
  // -------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getSavedMenus() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getCurrentUser();
    final username = user?['username'] ?? 'pengguna_fit';
    final jsonList = prefs.getStringList('ft_saved_menus_$username') ?? [];
    return jsonList
        .map((s) => Map<String, dynamic>.from(jsonDecode(s) as Map))
        .toList();
  }

  Future<void> saveFoodMenu(Map<String, dynamic> food) async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getCurrentUser();
    final username = user?['username'] ?? 'pengguna_fit';
    final key = 'ft_saved_menus_$username';
    final existing = prefs.getStringList(key) ?? [];

    // Cegah duplikasi berdasarkan id
    final existingMaps = existing
        .map((s) => Map<String, dynamic>.from(jsonDecode(s) as Map))
        .toList();
    if (existingMaps.any((m) => m['id'] == food['id'])) return;

    existing.insert(0, jsonEncode(food));
    await prefs.setStringList(key, existing);
  }

  Future<void> deleteSavedMenu(String foodId) async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getCurrentUser();
    final username = user?['username'] ?? 'pengguna_fit';
    final key = 'ft_saved_menus_$username';
    final existing = prefs.getStringList(key) ?? [];
    final updated = existing.where((s) {
      final m = Map<String, dynamic>.from(jsonDecode(s) as Map);
      return m['id'] != foodId;
    }).toList();
    await prefs.setStringList(key, updated);
  }

  Future<void> clearSavedMenus() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await getCurrentUser();
    final username = user?['username'] ?? 'pengguna_fit';
    await prefs.remove('ft_saved_menus_$username');
  }
}
