import 'package:flutter/material.dart';
import '../models/referans_model.dart';
import 'uretim_adedi_page.dart';

class MacaSayisiPage extends StatefulWidget {
  final List<ReferansModel> secilenReferanslar;

  const MacaSayisiPage({super.key, required this.secilenReferanslar});

  @override
  State<MacaSayisiPage> createState() => _MacaSayisiPageState();
}

class _MacaSayisiPageState extends State<MacaSayisiPage> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.secilenReferanslar.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _ilerle() {
    bool bosVar = _controllers.values.any((c) => c.text.trim().isEmpty);
    if (bosVar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm maça sayılarını girin')),
      );
      return;
    }

    for (var i = 0; i < widget.secilenReferanslar.length; i++) {
      widget.secilenReferanslar[i].macaSayisi = int.tryParse(_controllers[i]!.text.trim()) ?? 0;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UretimAdediPage(secilenReferanslar: widget.secilenReferanslar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maça Sayısı Gir')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.secilenReferanslar.length,
        itemBuilder: (context, index) {
          final r = widget.secilenReferanslar[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.referansAdi, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Maça Sayısı',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ilerle,
        icon: const Icon(Icons.arrow_forward),
        label: const Text('İlerle'),
      ),
    );
  }
}