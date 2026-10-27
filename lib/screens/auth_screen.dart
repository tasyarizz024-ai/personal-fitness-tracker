// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import '../main.dart';
import '../services/storage_service.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const AuthScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final StorageService _storageService = StorageService();
  bool _isLoginTab = false;

  // Controllers for Login
  final _loginIdController = TextEditingController();
  final _loginPassController = TextEditingController();

  // Controllers for Register
  final _regNameController = TextEditingController();
  final _regUsernameController = TextEditingController();
  final _regPassController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _loginIdController.dispose();
    _loginPassController.dispose();
    _regNameController.dispose();
    _regUsernameController.dispose();
    _regPassController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final id = _loginIdController.text.trim();
    final pass = _loginPassController.text.trim();
    if (id.isEmpty) {
      _showSnackbar('Masukkan username atau nama');
      return;
    }

    setState(() => _isLoading = true);
    final success = await _storageService.loginAccount(id, pass);
    setState(() => _isLoading = false);

    if (success) {
      widget.onLoginSuccess();
    } else {
      _showSnackbar(
          'Akun belum terdaftar atau kata sandi salah. Silakan daftar akun baru terlebih dahulu.');
      setState(() => _isLoginTab = false);
    }
  }

  Future<void> _handleRegister() async {
    final name = _regNameController.text.trim();
    final username = _regUsernameController.text.trim();
    final pass = _regPassController.text.trim();

    if (name.isEmpty || username.isEmpty || pass.isEmpty) {
      _showSnackbar('Semua kolom pendaftaran wajib diisi');
      return;
    }

    setState(() => _isLoading = true);
    final success = await _storageService.registerAccount(name, username, pass);
    setState(() => _isLoading = false);

    if (success) {
      _showSnackbar('Akun baru berhasil dibuat tanpa riwayat.');
      widget.onLoginSuccess();
    } else {
      _showSnackbar('Username sudah digunakan. Silakan gunakan username lain.');
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.cardSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Logo Badge
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'F',
                          style: TextStyle(
                            color: Color(0xFF04140E),
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'FitTrack',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Personal Fitness Tracker',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Auth Switch Tabs
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.cardAlt,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isLoginTab = true),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _isLoginTab
                                      ? AppColors.cardSurface
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: _isLoginTab
                                      ? Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.3))
                                      : null,
                                ),
                                child: Text(
                                  'Masuk',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _isLoginTab
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isLoginTab = false),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !_isLoginTab
                                      ? AppColors.cardSurface
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: !_isLoginTab
                                      ? Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.3))
                                      : null,
                                ),
                                child: Text(
                                  'Daftar Akun',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: !_isLoginTab
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // FORM CONTENT
                    if (_isLoginTab) ...[
                      _buildTextField(
                        controller: _loginIdController,
                        label: 'Username atau Nama',
                        hint: 'Masukkan username',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _loginPassController,
                        label: 'Kata Sandi',
                        hint: 'Masukkan kata sandi',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
                      const SizedBox(height: 24),
                      _buildActionButton(
                        label: 'Masuk ke FitTrack',
                        onPressed: _isLoading ? null : _handleLogin,
                      ),
                    ] else ...[
                      _buildTextField(
                        controller: _regNameController,
                        label: 'Nama Lengkap',
                        hint: 'Contoh: Rian Pratama',
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _regUsernameController,
                        label: 'Username Baru',
                        hint: 'Contoh: rian_fit',
                        icon: Icons.alternate_email_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _regPassController,
                        label: 'Kata Sandi',
                        hint: 'Minimal 4 karakter',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
                      const SizedBox(height: 24),
                      _buildActionButton(
                        label: 'Daftar & Mulai Latihan',
                        onPressed: _isLoading ? null : _handleRegister,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.textMuted, fontSize: 13),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
            filled: true,
            fillColor: AppColors.cardAlt,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      {required String label, required VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: const Color(0xFF04140E),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
