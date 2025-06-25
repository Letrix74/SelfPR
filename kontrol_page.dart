import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/referans_model.dart';
import '../models/uretim_model.dart';
import '../database/uretim_db_helper.dart';

class KontrolPage extends StatefulWidget {
  final List<ReferansModel> veriler;
  final bool fromMainPage;

  const KontrolPage({super.key, required this.veriler, required this.fromMainPage});

  @override
  State<KontrolPage> createState() => _KontrolPageState();
}

class _KontrolPageState extends State<KontrolPage> {
  late List<ReferansModel> _liste;

  @override
  void initState() {
    super.initState();
    _liste = List.from(widget.veriler);
  }

  void _sil(int index) {
    setState(() {
      _liste.removeAt(index);
    });
  }

  void _duzenle(int index) {
    // Düzenleme ekranı eklenebilir.
  }

  void _kaydet() async {
    final zaman = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    for (var r in _liste) {
      final model = UretimModel(
        referansAdi: r.referansAdi,
        vulkanizeKodu: r.vulkanizeKodu,
        ebosKodu: r.ebosKodu,
        macaSayisi: r.macaSayisi ?? 0,
        uretimAdedi: r.uretimAdedi ?? 0,
        kayitZamani: zaman,
      );
      await UretimDBHelper().insertUretim(model);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Üretim kaydedildi')),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kontrol Ekranı')),
      body: _liste.isEmpty
          ? const Center(child: Text('Hiç veri yok'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _liste.length,
        itemBuilder: (context, index) {
          final r = _liste[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(r.referansAdi, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Maça: ${r.macaSayisi}'),
                  Text('Üretim: ${r.uretimAdedi}'),
                  Text('Vulkanize: ${r.vulkanizeKodu}'),
                  Text('Eboş: ${r.ebosKodu}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _duzenle(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _sil(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _kaydet,
        icon: const Icon(Icons.save),
        label: const Text('Üretimi Kaydet'),
      ),
    );
  }
}