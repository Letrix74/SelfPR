import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/referans_model.dart';
import '../models/uretim_model.dart';
import '../database/uretim_db_helper.dart';

class KayitEklePage extends StatefulWidget {
  final ReferansModel referans;

  const KayitEklePage({super.key, required this.referans});

  @override
  State<KayitEklePage> createState() => _KayitEklePageState();
}

class _KayitEklePageState extends State<KayitEklePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _macaController = TextEditingController();
  final TextEditingController _adetController = TextEditingController();

  @override
  void dispose() {
    _macaController.dispose();
    _adetController.dispose();
    super.dispose();
  }

  void _kaydet() async {
    if (_formKey.currentState!.validate()) {
      final yeniKayit = UretimModel(
        referansAdi: widget.referans.referansAdi,
        vulkanizeKodu: widget.referans.vulkanizeKodu,
        ebosKodu: widget.referans.ebosKodu,
        macaSayisi: int.parse(_macaController.text),
        uretimAdedi: int.parse(_adetController.text),
        kayitZamani: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      );

      await UretimDBHelper().insertUretim(yeniKayit);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarıyla eklendi')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Kayıt Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Referans: ${widget.referans.referansAdi}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Vulkanize: ${widget.referans.vulkanizeKodu}'),
              Text('Eboş: ${widget.referans.ebosKodu}'),
              const SizedBox(height: 24),
              TextFormField(
                controller: _macaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Maça Sayısı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Üretim Adedi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Gerekli' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _kaydet,
                icon: const Icon(Icons.save),
                label: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}