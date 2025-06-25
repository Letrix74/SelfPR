import 'package:flutter/material.dart';
import '../models/referans_model.dart';
import 'kontrol_page.dart';

class UretimAdediPage extends StatefulWidget {
  final List<ReferansModel> secilenReferanslar;

  const UretimAdediPage({super.key, required this.secilenReferanslar});

  @override
  State<UretimAdediPage> createState() => _UretimAdediPageState();
}

class _UretimAdediPageState extends State<UretimAdediPage> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.secilenReferanslar.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  void _ilerle() {
    bool bosVar = _controllers.values.any((controller) => controller.text.trim().isEmpty);
    if (bosVar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tüm üretim adetlerini doldurun')),
      );
      return;
    }

    for (int i = 0; i < widget.secilenReferanslar.length; i++) {
      widget.secilenReferanslar[i].uretimAdedi = int.tryParse(_controllers[i]!.text.trim()) ?? 0;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KontrolPage(veriler: widget.secilenReferanslar, fromMainPage: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üretim Adedi Gir'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: widget.secilenReferanslar.length,
        itemBuilder: (context, index) {
          final r = widget.secilenReferanslar[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(r.referansAdi),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Maça: ${r.macaSayisi ?? '-'}'),
                  Text('Vulkanize: ${r.vulkanizeKodu}'),
                  Text('Eboş: ${r.ebosKodu}'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Üretim Adedi',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
