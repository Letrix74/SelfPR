import 'package:flutter/material.dart';
import '../models/referans_model.dart';
import '../database/referans_db_helper.dart';
import 'app_drawer.dart';

class ReferansDuzenlePage extends StatefulWidget {
  const ReferansDuzenlePage({super.key});

  @override
  State<ReferansDuzenlePage> createState() => _ReferansDuzenlePageState();
}

class _ReferansDuzenlePageState extends State<ReferansDuzenlePage> {
  final TextEditingController _aramaController = TextEditingController();
  List<ReferansModel> _liste = [];

  @override
  void initState() {
    super.initState();
    _listeyiYenile();
  }

  Future<void> _listeyiYenile([String? arama]) async {
    final veriler = await ReferansDBHelper().getReferanslar(arama: arama);
    setState(() {
      _liste = veriler;
    });
  }

  void _formAc({ReferansModel? duzenlenecek}) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _referansController =
    TextEditingController(text: duzenlenecek?.referansAdi ?? '');
    final TextEditingController _vulkanizeController =
    TextEditingController(text: duzenlenecek?.vulkanizeKodu ?? '');
    final TextEditingController _ebosController =
    TextEditingController(text: duzenlenecek?.ebosKodu ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                duzenlenecek == null ? 'Yeni Referans Ekle' : 'Referansı Güncelle',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _referansController,
                decoration: const InputDecoration(
                  labelText: 'Referans Adı',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _vulkanizeController,
                decoration: const InputDecoration(
                  labelText: 'Vulkanize Kodu',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ebosController,
                decoration: const InputDecoration(
                  labelText: 'Eboş Kodu',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Zorunlu' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(duzenlenecek == null ? 'Kaydet' : 'Güncelle'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final yeni = ReferansModel(
                      id: duzenlenecek?.id,
                      referansAdi: _referansController.text.trim(),
                      vulkanizeKodu: _vulkanizeController.text.trim(),
                      ebosKodu: _ebosController.text.trim(),
                    );

                    final tumKayitlar = await ReferansDBHelper().getReferanslar();
                    final tekrarVarMi = tumKayitlar.any((r) {
                      if (duzenlenecek != null && r.id == duzenlenecek.id) return false;
                      return r.referansAdi == yeni.referansAdi ||
                          r.vulkanizeKodu == yeni.vulkanizeKodu ||
                          r.ebosKodu == yeni.ebosKodu;
                    });

                    if (tekrarVarMi) {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Hata'),
                            content: const Text('Vulkanize & Eboş kodu zaten mevcut.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Tamam'),
                              ),
                            ],
                          ),
                        );
                      }
                      return;
                    }

                    if (duzenlenecek == null) {
                      await ReferansDBHelper().insertReferans(yeni);
                    } else {
                      await ReferansDBHelper().updateReferans(yeni);
                    }

                    if (context.mounted) Navigator.pop(context);
                    _listeyiYenile(_aramaController.text);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onayliSil(int id) async {
    final sonuc = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(child: const Text('Vazgeç'), onPressed: () => Navigator.pop(ctx, false)),
          ElevatedButton(child: const Text('Sil'), onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );
    if (sonuc == true) {
      await ReferansDBHelper().deleteReferans(id);
      _listeyiYenile(_aramaController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referans Düzenleme'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _aramaController,
              decoration: InputDecoration(
                hintText: 'Referans, Vulkanize veya Eboş ara',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _listeyiYenile,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _liste.length,
              itemBuilder: (context, index) {
                final r = _liste[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    title: Text(r.referansAdi, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vulkanize: ${r.vulkanizeKodu}'),
                          Text('Eboş: ${r.ebosKodu}'),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _formAc(duzenlenecek: r),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _onayliSil(r.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _formAc(),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Referans'),
      ),
    );
  }
}