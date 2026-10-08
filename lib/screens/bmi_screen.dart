import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../main.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({Key? key}) : super(key: key);

  @override
  _BmiScreenState createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  double? _bmi;
  String _category = '';
  Color _categoryColor = AppColors.primary;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _calculateBmi() {
    if (_formKey.currentState!.validate()) {
      final double weight = double.parse(_weightController.text);
      final double heightCm = double.parse(_heightController.text);
      final double heightM = heightCm / 100;

      setState(() {
        _bmi = weight / (heightM * heightM);

        if (_bmi! < 18.5) {
          _category = 'Kurus (Underweight)';
          _categoryColor = const Color(0xFF3B82F6);
        } else if (_bmi! < 24.9) {
          _category = 'Normal';
          _categoryColor = AppColors.primary;
        } else if (_bmi! < 29.9) {
          _category = 'Gemuk (Overweight)';
          _categoryColor = const Color(0xFFF59E0B);
        } else {
          _category = 'Obesitas';
          _categoryColor = AppColors.error;
        }
      });

      _animController.reset();
      _animController.forward();
    }
  }

  double get _bmiProgress {
    if (_bmi == null) return 0;
    return ((_bmi! - 10) / 30).clamp(0.0, 1.0);
  }

  InputDecoration _inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 14),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.secondary.withOpacity(0.5), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kalkulator BMI'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1E876C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Hitung BMI kamu',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Body Mass Index (BMI) adalah indikator sederhana untuk mengetahui status berat badan.',
                          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.monitor_weight_rounded, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Input Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Berat Badan (kg)', 'Contoh: 65', Icons.line_weight_rounded),
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Berat badan belum diisi';
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Nilai harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Tinggi Badan (cm)', 'Contoh: 170', Icons.height_rounded),
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Tinggi badan belum diisi';
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Nilai harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Calculate Button
                  GestureDetector(
                    onTap: _calculateBmi,
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF1E876C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calculate_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Hitung BMI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BMI Result
            if (_bmi != null) ...[
              const SizedBox(height: 28),
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _categoryColor.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: _categoryColor.withOpacity(0.2), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text('BMI Kamu', style: TextStyle(fontSize: 14, color: AppColors.textSecondary.withOpacity(0.8))),
                      const SizedBox(height: 12),
                      Text(
                        _bmi!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: _categoryColor,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: _categoryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          _category,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // BMI Scale Bar
                      _buildBmiScale(),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: AppColors.textSecondary, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Hasil ini hanyalah informasi umum dan bukan diagnosis medis.',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildBmiCategories(),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiScale() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Posisi BMI kamu', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3B82F6),
                    Color(0xFF176B55),
                    Color(0xFFF59E0B),
                    Color(0xFFD96B6B),
                  ],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width - 88) * _bmiProgress,
              child: Container(
                width: 14,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kurus\n<18.5', style: TextStyle(fontSize: 10, color: Color(0xFF3B82F6)), textAlign: TextAlign.center),
            Text('Normal\n18.5-24.9', style: TextStyle(fontSize: 10, color: AppColors.primary), textAlign: TextAlign.center),
            Text('Gemuk\n25-29.9', style: TextStyle(fontSize: 10, color: Color(0xFFF59E0B)), textAlign: TextAlign.center),
            Text('Obesitas\n>30', style: TextStyle(fontSize: 10, color: AppColors.error), textAlign: TextAlign.center),
          ],
        ),
      ],
    );
  }

  Widget _buildBmiCategories() {
    final categories = [
      {'label': 'Kurus', 'range': '< 18.5', 'color': const Color(0xFF3B82F6)},
      {'label': 'Normal', 'range': '18.5 – 24.9', 'color': AppColors.primary},
      {'label': 'Gemuk', 'range': '25 – 29.9', 'color': const Color(0xFFF59E0B)},
      {'label': 'Obesitas', 'range': '≥ 30', 'color': AppColors.error},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kategori BMI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          ...categories.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: c['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(c['label'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (c['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    c['range'] as String,
                    style: TextStyle(color: c['color'] as Color, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
