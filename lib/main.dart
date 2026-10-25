import 'package:flutter/material.dart';

void main() {
  runApp(const SteelApp());
}

class SteelApp extends StatelessWidget {
  const SteelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'محاسبه وزن',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
        fontFamily: 'Vazirmatn',
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

  String product = 'ورق';

  final lengthCtrl = TextEditingController(text: '6');
  final widthCtrl = TextEditingController(text: '1500');
  final thicknessCtrl = TextEditingController(text: '2');
  final diameterCtrl = TextEditingController(text: '50');
  final sideACtrl = TextEditingController(text: '40');
  final sideBCtrl = TextEditingController(text: '40');
  final countCtrl = TextEditingController(text: '1');

  double? weightOne;
  double? weightTotal;

  static const double density = 7.85;

  @override
  void dispose() {
    lengthCtrl.dispose();
    widthCtrl.dispose();
    thicknessCtrl.dispose();
    diameterCtrl.dispose();
    sideACtrl.dispose();
    sideBCtrl.dispose();
    countCtrl.dispose();
    super.dispose();
  }

  double _p(String s) {
    return double.tryParse(s.trim().replaceAll('،', '.').replaceAll(',', '.')) ?? 0;
  }

  void _calc() {
    double L = 0;
    double W = 0;
    double t = 0;
    double D = 0;
    double A = 0;
    double B = 0;
    int count = int.tryParse(countCtrl.text.trim()) ?? 1;
    if (count < 1) count = 1;

    double one = 0;

    if (product == 'ورق') {
      L = _p(lengthCtrl.text);
      W = _p(widthCtrl.text) / 1000.0;
      t = _p(thicknessCtrl.text);
      one = L * W * t * density;
    } else if (product == 'لوله گرد') {
      D = _p(diameterCtrl.text);
      t = _p(thicknessCtrl.text);
      L = _p(lengthCtrl.text);
      // مدل بازاری لوله: D * t بدون کم کردن ضخامت
      one = 3.1416 * density / 1000 * D * t * L;
    } else if (product == 'پروفیل مربع') {
      A = _p(sideACtrl.text);
      t = _p(thicknessCtrl.text);
      L = _p(lengthCtrl.text);
      // مدل بازاری پروفیل مربع: 4 * A * t
      one = 4 * A * t * L * 0.00785;
    } else if (product == 'پروفیل مستطیل') {
      A = _p(sideACtrl.text);
      B = _p(sideBCtrl.text);
      t = _p(thicknessCtrl.text);
      L = _p(lengthCtrl.text);
      // مدل بازاری پروفیل مستطیل: 2 * (A + B) * t
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

    setState(() {
      weightOne = one;
      weightTotal = one * count;
    });
  }

  Widget _field(TextEditingController c, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
      ),
    );
  }

  List<Widget> _inputs() {
    if (product == 'ورق') {
      return [
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6'),
        _field(widthCtrl, 'عرض (میلی‌متر)', 'مثلا 1500'),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 2'),
      ];
    } else if (product == 'لوله گرد') {
      return [
        _field(diameterCtrl, 'قطر خارجی (میلی‌متر)', 'مثلا 51'),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 1.5'),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6'),
      ];
    } else if (product == 'پروفیل مربع') {
      return [
        _field(sideACtrl, 'ضلع (میلی‌متر)', 'مثلا 40'),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 2'),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6'),
      ];
    } else if (product == 'پروفیل مستطیل') {
      return [
        _field(sideACtrl, 'ضلع A (میلی‌متر)', 'مثلا 40'),
        _field(sideBCtrl, 'ضلع B (میلی‌متر)', 'مثلا 80'),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 2'),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6'),
      ];
    } else if (product == 'میلگرد') {
      return [
        _field(diameterCtrl, 'قطر (میلی‌متر)', 'مثلا 16'),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 12'),
      ];
    } else if (product == 'تسمه') {
      return [
        _field(widthCtrl, 'عرض (میلی‌متر)', 'مثلا 50'),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 5'),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6'),
      ];
    } else {
      return [
        _field(sideACtrl, 'بال A (میلی‌متر)', 'مثلا 50'),
        _field(sideBCtrl, 'بال B (میلی‌متر)', 'مثلا 50'),
        _field(thicknessCtrl, 'ضخامت (میلی‌متر)', 'مثلا 5'),
        _field(lengthCtrl, 'طول (متر)', 'مثلا 6'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ماشین‌حساب وزن مقاطع'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueGrey.shade200),
                ),
                child: const Text(
                  'چگالی برای همه محصولات: 7.85 گرم بر سانتی‌متر مکعب - محاسبه لوله و پروفیل به روش بازاری',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: product,
                decoration: InputDecoration(
                  labelText: 'نوع محصول',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: products.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    product = v;
                    weightOne = null;
                    weightTotal = null;
                  });
                },
              ),
              const SizedBox(height: 12),
              ..._inputs(),
              _field(countCtrl, 'تعداد (شاخه / عدد)', 'مثلا 1'),
              const SizedBox(height: 4),
              FilledButton(
                onPressed: _calc,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('محاسبه وزن', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              if (weightOne != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'وزن هر شاخه: ${weightOne!.toStringAsFixed(3)} کیلوگرم',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'وزن کل: ${weightTotal!.toStringAsFixed(3)} کیلوگرم',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}