// lib/screens/bmi_screen.dart
import 'package:flutter/material.dart';
import '../main.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({Key? key}) : super(key: key);

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  String _gender = 'f'; // 'f' atau 'm'
  int _weightKg = 54;
  int _heightCm = 162;
  int _ageYears = 24;

  double _bmi = 20.6;
  String _category = 'Normal (Ideal)';
  String _idealRange = '48.6 kg – 65.3 kg';
  String _advice =
      'Bagus sekali! Berat badanmu dalam rentang ideal untuk tinggi badan 162 cm. Pertahankan rutinitas latihan 3–4× seminggu dan asupan gizi seimbang.';

  @override
  void initState() {
    super.initState();
    _calculateBmi();
  }

  void _calculateBmi() {
    final hM = _heightCm / 100.0;
    final bmiVal = _weightKg / (hM * hM);

    final minIdeal = (18.5 * hM * hM).toStringAsFixed(1);
    final maxIdeal = (24.9 * hM * hM).toStringAsFixed(1);

    String cat;
    String adv;

    if (bmiVal < 18.5) {
      cat = 'Kurus (Bobot Kurang)';
      adv =
          'Indeks massa tubuhmu di bawah normal. Tingkatkan asupan kalori bernutrisi dan lakukan latihan beban secara bertahap.';
    } else if (bmiVal <= 24.9) {
      cat = 'Normal (Ideal)';
      adv =
          'Bagus sekali! Berat badanmu dalam rentang ideal untuk tinggi badan $_heightCm cm. Pertahankan rutinitas latihan 3–4× seminggu dan asupan gizi seimbang.';
    } else if (bmiVal <= 29.9) {
      cat = 'Kelebihan Bobot';
      adv =
          'Indeks massa tubuhmu sedikit di atas batas normal. Tingkatkan aktivitas kardio harian (Lari, Sepeda) dan jaga pola makan.';
    } else {
      cat = 'Obesitas';
      adv =
          'Perhatikan kesehatanmu dengan olahraga intensitas terukur (Jalan Kaki, Renang) dan konsultasikan pola makan dengan ahli gizi.';
    }

    setState(() {
      _bmi = double.parse(bmiVal.toStringAsFixed(1));
      _category = cat;
      _idealRange = '$minIdeal kg – $maxIdeal kg';
      _advice = adv;
    });
  }

  void _saveBmiLog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Catatan BMI $_bmi kg/m² berhasil disimpan! ✨'),
        backgroundColor: const Color(0xFF1B2232),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
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
                  Text('FITTRACK',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E2434))),
                  Text('Bmi',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80'),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: const [
                Icon(Icons.favorite_rounded,
                    color: AppColors.primary, size: 14),
                SizedBox(width: 6),
                Text('Kesehatan Personal',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 4),
            const Text('Kalkulator BMI',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF151828))),
            const SizedBox(height: 4),
            const Text(
              'Pantau indeks massa tubuh dan komposisi berat badan idealmu secara teratur.',
              style: TextStyle(
                  fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 20),

            // Card 1: Input Form
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('JENIS KELAMIN',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.6)),
                  const SizedBox(height: 10),

                  // Gender Toggle Buttons
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() => _gender = 'f');
                            _calculateBmi();
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _gender == 'f'
                                  ? AppColors.primary
                                  : const Color(0xFFF1F4FB),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Text(
                                '♀ Wanita',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: _gender == 'f'
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() => _gender = 'm');
                            _calculateBmi();
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _gender == 'm'
                                  ? AppColors.primary
                                  : const Color(0xFFF1F4FB),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                              child: Text(
                                '♂ Pria',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: _gender == 'm'
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Berat Badan
                  _buildBmiStepperRow(
                    label: 'Berat Badan',
                    unit: 'Satuan: kg',
                    value: '$_weightKg',
                    displayUnit: 'kg',
                    onMinus: () {
                      setState(
                          () => _weightKg = (_weightKg - 1).clamp(20, 250));
                      _calculateBmi();
                    },
                    onPlus: () {
                      setState(
                          () => _weightKg = (_weightKg + 1).clamp(20, 250));
                      _calculateBmi();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tinggi Badan
                  _buildBmiStepperRow(
                    label: 'Tinggi Badan',
                    unit: 'Satuan: cm',
                    value: '$_heightCm',
                    displayUnit: 'cm',
                    onMinus: () {
                      setState(
                          () => _heightCm = (_heightCm - 1).clamp(80, 250));
                      _calculateBmi();
                    },
                    onPlus: () {
                      setState(
                          () => _heightCm = (_heightCm + 1).clamp(80, 250));
                      _calculateBmi();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Usia
                  _buildBmiStepperRow(
                    label: 'Usia',
                    unit: 'Tahun',
                    value: '$_ageYears',
                    displayUnit: 'th',
                    isUnitTextOnly: true,
                    onMinus: () {
                      setState(
                          () => _ageYears = (_ageYears - 1).clamp(10, 100));
                      _calculateBmi();
                    },
                    onPlus: () {
                      setState(
                          () => _ageYears = (_ageYears + 1).clamp(10, 100));
                      _calculateBmi();
                    },
                  ),
                  const SizedBox(height: 18),

                  // Tombol Hitung BMI
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _calculateBmi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        textStyle: const TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w800),
                      ),
                      icon: const Icon(Icons.calculate_outlined, size: 20),
                      label: const Text('Hitung BMI'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card 2: HASIL ANALISIS
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('HASIL ANALISIS',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.6)),
                          SizedBox(height: 2),
                          Text('Skor BMI Kamu',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF151828))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '✓ $_category',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF264005)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Skor Besar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '$_bmi ',
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF151828)),
                          children: const [
                            TextSpan(
                                text: 'kg/m²',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2638),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '❮ Kondisi Prima',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Visual Gauge Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 10,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF93C5FD),
                            Color(0xFFA7F3D0),
                            Color(0xFFD2FB52),
                            Color(0xFFFED7AA),
                            Color(0xFFFCA5A5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGaugeCol('Kurus', '< 18.5'),
                      _buildGaugeCol('Normal', '18.5 - 24.9', isBold: true),
                      _buildGaugeCol('Lebih', '25 - 29.9'),
                      _buildGaugeCol('Obesitas', '≥ 30.0', isRed: true),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rentang Berat Ideal Box
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1EFFE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.scale_rounded,
                                  color: AppColors.primary, size: 18),
                            ),
                            const SizedBox(width: 10),
                            const Text('Rentang Berat Ideal',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF151828))),
                          ],
                        ),
                        Text(_idealRange,
                            style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Saran Gaya Hidup Sehat Callout Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F5FE),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lightbulb_outline_rounded,
                              color: Color(0xFF264005), size: 16),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Saran Gaya Hidup Sehat',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF151828))),
                              const SizedBox(height: 4),
                              Text(_advice,
                                  style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textSecondary,
                                      height: 1.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Card 3: Simpan Catatan Hari Ini
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EFFE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Simpan Catatan Hari Ini',
                            style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF151828))),
                        SizedBox(height: 2),
                        Text('Lacak riwayat perubahan fisikmu',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveBmiLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: const Color(0xFF264005),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      textStyle: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w800),
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiStepperRow({
    required String label,
    required String unit,
    required String value,
    required String displayUnit,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    bool isUnitTextOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF151828))),
            if (isUnitTextOnly)
              Text(unit,
                  style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary))
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EFFE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(unit,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FE),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallStepBtn('−', onMinus),
              RichText(
                text: TextSpan(
                  text: '$value ',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF151828)),
                  children: [
                    TextSpan(
                        text: displayUnit,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              _buildSmallStepBtn('+', onPlus),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStepBtn(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFEDF0FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF151828))),
        ),
      ),
    );
  }

  Widget _buildGaugeCol(String title, String range,
      {bool isBold = false, bool isRed = false}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: isRed ? const Color(0xFFDC2626) : const Color(0xFF151828),
          ),
        ),
        const SizedBox(height: 1),
        Text(range,
            style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted)),
      ],
    );
  }
}
