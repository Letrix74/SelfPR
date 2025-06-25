import 'package:flutter/material.dart';
import '../database/referans_db_helper.dart';
import '../models/referans_model.dart';
import 'maca_sayisi_page.dart';

class ReferansSecimPage extends StatefulWidget {
  const ReferansSecimPage({super.key});

  @override
  State<ReferansSecimPage> createState() => _ReferansSecimPageState();
}

class _ReferansSecimPageState extends State<ReferansSecimPage> {
  List<ReferansModel> _tumReferanslar = [];
  List<ReferansModel> _secilenler = [];
  final TextEditingController _aramaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  Future<void> _verileriGetir([String? arama]) async {
    final veriler = await ReferansDBHelper().getReferanslar(arama: arama);
    setState(() {
      _tumReferanslar = veriler;
    });
  }

  void _ilerle() {
    if (_secilenler.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir referans seçin')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MacaSayisiPage(secilenReferanslar: _secilenler),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referans Seçimi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              controller: _aramaController,
              decoration: InputDecoration(
                hintText: 'Referans ara...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _verileriGetir,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tumReferanslar.length,
              itemBuilder: (context, index) {
                final r = _tumReferanslar[index];
                final secildi = _secilenler.contains(r);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: CheckboxListTile(
                    title: Text(r.referansAdi),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vulkanize: ${r.vulkanizeKodu}'),
                        Text('Eboş: ${r.ebosKodu}'),
                      ],
                    ),
                    value: secildi,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _secilenler.add(r);
                        } else {
                          _secilenler.remove(r);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ilerle,
        icon: const Icon(Icons.arrow_forward),
        label: const Text('İlerle'),
      ),
    );
  }
}