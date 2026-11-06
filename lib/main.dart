import 'package:flutter/material.dart';

void main() {
  runApp(const SteelApp());
}

class SteelApp extends StatelessWidget {
  const SteelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'محاسبه‌گر وزن مقاطع استنلس استیل',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F2A44),
          brightness: Brightness.light,
        ),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final List<String> products = [
    'ورق',
    'لوله گرد',
    'پروفیل مربع',
    'پروفیل مستطیل',
    'میلگرد',
    'تسمه',
    'نبشی',
  ];

  final Map<String, IconData> icons = {
    'ورق': Icons.layers_outlined,
    'لوله گرد': Icons.donut_large,
    'پروفیل مربع': Icons.crop_square,
    'پروفیل مستطیل': Icons.crop_landscape,
    'میلگرد': Icons.straighten,
    'تسمه': Icons.view_day_outlined,
    'نبشی': Icons.crop_free,
  };

  String product = 'ورق';

  final lengthCtrl = TextEditingController(text: '6');
  final sheetWidthCtrl = TextEditingController(text: '1.5');
  final widthCtrl = TextEditingController(text: '50');
  final thicknessCtrl = TextEditingController(text: '2');
  final diameterCtrl = TextEditingController(text: '50');
  final sideACtrl = TextEditingController(text: '40');
  final sideBCtrl = TextEditingController(text: '40');
  final countCtrl = TextEditingController(text: '1');
  final priceCtrl = TextEditingController(text: '');

  double? weightOne;
  double? weightTotal;
  double? totalPrice;

  static const double density = 7.85;

  String get countLabel => product == 'ورق' ? 'تعداد (برگ)' : 'تعداد (شاخه)';

  @override
  void dispose() {
    lengthCtrl.dispose();
    sheetWidthCtrl.dispose();
    widthCtrl.dispose();
    thicknessCtrl.dispose();
    diameterCtrl.dispose();
    sideACtrl.dispose();
    sideBCtrl.dispose();
    countCtrl.dispose();
    priceCtrl.dispose();
    super.dispose();
  }

  String _toEnglishDigits(String s) {
    const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const ar = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < 10; i++) {
      s = s.replaceAll(fa[i], i.toString());
      s = s.replaceAll(ar[i], i.toString());
    }
    return s;
  }

  String _groupDigits(String digits) {
    if (digits.isEmpty) return '';
    digits = digits.replaceFirst(RegExp(r'^0+'), '');
    if (digits.isEmpty) digits = '0';
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return digits.replaceAllMapped(reg, (m) => ',');
  }

  void _onPriceChanged(String v) {
    String en = _toEnglishDigits(v);
    String digitsOnly = en.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return;
    String formatted = _groupDigits(digitsOnly);
    if (formatted != v) {
      priceCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  double _p(String s) {
    String en = _toEnglishDigits(s);
    en = en.trim().replaceAll('٬', '').replaceAll(',', '').replaceAll(' ', '').replaceAll('،', '.').replaceAll('٫', '.');
    return double.tryParse(en) ?? 0;
  }

  double _parsePrice(String s) {
    String en = _toEnglishDigits(s);
    en = en.replaceAll(',', '').replaceAll('٬', '').replaceAll('،', '').replaceAll(' ', '');
    return double.tryParse(en) ?? 0;
  }

  String _formatMoney(double v) {
    final intVal = v.round();
    final s = intVal.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => ',');
  }

  void _calc() {
    double L = 0;
    double W = 0;
    double t = 0;
    double D = 0;
    double A = 0;
    double B = 0;
    int count = int.tryParse(_toEnglishDigits(countCtrl.text.trim()).replaceAll(',', '')) ?? 1;
    if (count < 1) count = 1;

    double one = 0;

    if (product == 'ورق') {
      L = _p(lengthCtrl.text);
      W = _p(sheetWidthCtrl.text);
      t = _p(thicknessCtrl.text);
      one = L * W * t * density;
    } else if (product == 'لوله گرد') {
      D = _p(diameterCtrl.text);
      t = _p(thicknessCtrl.text);
      L = _p(lengthCtrl.text);
      one = 3.1416 * density / 1000 * D * t * L;
    } else if (product == 'پروفیل مربع') {
      A = _p(sideACtrl.text);
      t = _p(thicknessCtrl.text);
      L = _p(lengthCtrl.text);
      one = 4 * A * t * L * 0.00785;
    } else if (product == 'پروفیل مستطیل') {
      A = _p(sideACtrl.text);
      B = _p(sideBCtrl.text);
      t = _p(thicknessCtrl.text);
      L = _p(lengthCtrl.text);
      one = 2 * (A + B) * t * L * 0.00785;
    } else if (product == 'میلگرد') {
      D = _p(diameterCtrl.text);
      L = _p(lengthCtrl.text);
      one = D * D * L * 0.006165;
    } else if (product == 'تسمه') {
      W = _p(widthCtrl.text);
      t = _p(thicknessCtrl.text);
      L = _p(lengthCtrl.text);
      one = W * t * L * 0.00785;
    } else if (product == 'نبشی') {
      A = _p(sideACtrl.text);
      B = _p(sideBCtrl.text);
      t = _p(thicknessCtrl.text);
      L = _p(lengthCtrl.text);
      one = (A + B - t) * t * L * 0.00785;
    }

    double priceUnit = _parsePrice(priceCtrl.text);
    double total = one * count;

    setState(() {
      weightOne = one;
      weightTotal = total;
      totalPrice = total * priceUnit;
    });
  }

  Widget _field(TextEditingController c, String label, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onTap: () => c.clear(),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.blueGrey.shade200),
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _priceField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: priceCtrl,
        keyboardType: TextInputType.number,
        onTap: () => priceCtrl.clear(),
        onChanged: _onPriceChanged,
        decoration: InputDecoration(
          labelText: 'قیمت واحد (تومان)',
          hintText: 'مثلا 450,000',
          prefixIcon: const Icon(Icons.payments_outlined, size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.blueGrey.shade200),
          ),
          isDense: true,
        ),
      ),
    );
  }

  List<Widget> _inputs() {
    if (product == 'ورق') {
      return [
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6', Icons.straighten),
        _field(sheetWidthCtrl, 'عرض (متر)', 'مثلا 1.5', Icons.width_full_outlined),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 2', Icons.vertical_align_center),
      ];
    } else if (product == 'لوله گرد') {
      return [
        _field(diameterCtrl, 'قطر خارجی (میلی‌متر)', 'مثلا 51', Icons.donut_large),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 1.5', Icons.vertical_align_center),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6', Icons.straighten),
      ];
    } else if (product == 'پروفیل مربع') {
      return [
        _field(sideACtrl, 'ضلع (میلی‌متر)', 'مثلا 40', Icons.crop_square),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 2', Icons.vertical_align_center),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6', Icons.straighten),
      ];
    } else if (product == 'پروفیل مستطیل') {
      return [
        _field(sideACtrl, 'ضلع A (میلی‌متر)', 'مثلا 40', Icons.crop_landscape),
        _field(sideBCtrl, 'ضلع B (میلی‌متر)', 'مثلا 80', Icons.crop_landscape),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 2', Icons.vertical_align_center),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6', Icons.straighten),
      ];
    } else if (product == 'میلگرد') {
      return [
        _field(diameterCtrl, 'قطر (میلی‌متر)', 'مثلا 16', Icons.circle_outlined),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 12', Icons.straighten),
      ];
    } else if (product == 'تسمه') {
      return [
        _field(widthCtrl, 'عرض (میلی‌متر)', 'مثلا 50', Icons.view_day_outlined),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 5', Icons.vertical_align_center),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6', Icons.straighten),
      ];
    } else {
      return [
        _field(sideACtrl, 'بال A (میلی‌متر)', 'مثلا 50', Icons.crop_free),
        _field(sideBCtrl, 'بال B (میلی‌متر)', 'مثلا 50', Icons.crop_free),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 5', Icons.vertical_align_center),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6', Icons.straighten),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 150,
              backgroundColor: const Color(0xFF0F2A44),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFF0F2A44),
                        Color(0xFF1E4E79),
                        Color(0xFF3A8DDE),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'محاسبه‌گر وزن مقاطع استنلس استیل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: const Text(
                              'چگالی 7.85 • محاسبه وزن و قیمت',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'نوع محصول',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, i) {
                        final e = products[i];
                        final selected = e == product;
                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            setState(() {
                              product = e;
                              weightOne = null;
                              weightTotal = null;
                              totalPrice = null;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              gradient: selected
                                  ? const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF1E4E79), Color(0xFF0F2A44)],
                              )
                                  : null,
                              color: selected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF0F2A44)
                                    : Colors.blueGrey.shade200,
                                width: selected ? 1.5 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(selected ? 0.2 : 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icons[e],
                                  color: selected ? Colors.white : const Color(0xFF0F2A44),
                                  size: 26,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  e,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: selected ? Colors.white : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F2A44).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.edit_note,
                                    color: Color(0xFF0F2A44)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'مشخصات $product',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._inputs(),
                          _field(countCtrl, countLabel, 'مثلا 1',
                              Icons.numbers_outlined),
                          _priceField(),
                          const SizedBox(height: 4),
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: _calc,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF3A8DDE), Color(0xFF0F2A44)],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0F2A44).withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calculate_outlined,
                                      color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'محاسبه وزن و قیمت',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (weightOne != null)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Color(0xFF0F2A44), Color(0xFF2A6BA3)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F2A44).withOpacity(0.3),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.scale_outlined,
                                        color: Colors.white70, size: 20),
                                    SizedBox(width: 6),
                                    Text('نتیجه وزن',
                                        style: TextStyle(
                                            color: Colors.white70, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${weightOne!.toStringAsFixed(3)} کیلوگرم',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'وزن هر شاخه',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('وزن کل:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${weightTotal!.toStringAsFixed(3)} kg',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: Color(0xFF0F2A44)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD76A), Color(0xFFF5A623)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.payments_outlined,
                                        color: Color(0xFF4A2E00)),
                                    SizedBox(width: 8),
                                    Text(
                                      'قیمت کل:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                          color: Color(0xFF4A2E00)),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${_formatMoney(totalPrice ?? 0)} تومان',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                      color: Color(0xFF4A2E00)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'چگالی ثابت 7.85 گرم بر سانتی‌متر مکعب',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}