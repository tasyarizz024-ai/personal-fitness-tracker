// lib/screens/saved_menus_screen.dart
import 'package:flutter/material.dart';
import '../main.dart';
import '../services/storage_service.dart';

class SavedMenusScreen extends StatefulWidget {
  const SavedMenusScreen({Key? key}) : super(key: key);

  @override
  State<SavedMenusScreen> createState() => _SavedMenusScreenState();
}

class _SavedMenusScreenState extends State<SavedMenusScreen> {
  final StorageService _storageService = StorageService();
  List<Map<String, dynamic>> _savedMenus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    setState(() => _isLoading = true);
    final menus = await _storageService.getSavedMenus();
    setState(() {
      _savedMenus = menus;
      _isLoading = false;
    });
  }

  Future<void> _deleteMenu(String foodId) async {
    await _storageService.deleteSavedMenu(foodId);
    setState(() {
      _savedMenus.removeWhere((m) => m['id'] == foodId);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Menu dihapus dari daftar tersimpan'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Semua?',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Semua menu tersimpan akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _storageService.clearSavedMenus();
      setState(() => _savedMenus = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleSpacing: 20,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(Icons.all_inclusive_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'FITTRACK',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E2434),
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    'Menu Tersimpan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            if (_savedMenus.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.delete_sweep_rounded,
                      size: 16, color: AppColors.accentCoral),
                  label: const Text(
                    'Hapus Semua',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentCoral,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _savedMenus.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: Colors.white,
                  onRefresh: _loadMenus,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    children: [
                      // Header info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE4E2FD), Color(0xFFF4FBF0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.12)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.bookmark_rounded,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_savedMenus.length} Menu Tersimpan',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF151828),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Rekomendasi nutrisi pasca-latihan pilihanmu',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // List of saved menus
                      ..._savedMenus.map((food) => _buildFoodCard(food)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> food) {
    final imageUrl = food['image'] as String? ?? '';
    final name = food['name'] as String? ?? '';
    final category = food['category'] as String? ?? '';
    final protein = food['protein'] as String? ?? '';
    final calories = food['calories'] as String? ?? '';
    final desc = food['desc'] as String? ?? '';
    final foodId = food['id'] as String? ?? '';
    final savedAt = food['savedAt'] as String?;

    return Dismissible(
      key: Key(foodId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.accentCoral,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 26),
      ),
      onDismissed: (_) => _deleteMenu(foodId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Food image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 86,
                      height: 86,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        width: 86,
                        height: 86,
                        color: const Color(0xFFEEF2FA),
                        child: const Icon(Icons.restaurant_rounded,
                            color: AppColors.primary),
                      ),
                    )
                  : Container(
                      width: 86,
                      height: 86,
                      color: const Color(0xFFEEF2FA),
                      child: const Icon(Icons.restaurant_rounded,
                          color: AppColors.primary),
                    ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category.isNotEmpty)
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF151828),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (protein.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            protein,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF264005),
                            ),
                          ),
                        ),
                      if (protein.isNotEmpty && calories.isNotEmpty)
                        const SizedBox(width: 6),
                      if (calories.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDFF6F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            calories,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (savedAt != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.bookmark_rounded,
                            size: 10, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Disimpan $savedAt',
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Delete button
            GestureDetector(
              onTap: () => _deleteMenu(foodId),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.accentCoral, size: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFEEECFD),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bookmark_border_rounded,
                  color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Menu Tersimpan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF151828),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Simpan rekomendasi makananmu setelah berolahraga agar mudah ditemukan lagi di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                '💪 Selesaikan olahraga & simpan menumu!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF264005),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
