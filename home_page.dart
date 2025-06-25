import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/uretim_model.dart';
import '../database/uretim_db_helper.dart';
import 'referans_secim_page.dart';
import 'app_drawer.dart';
import 'uretim_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, List<UretimModel>> grupluUretimler = {};

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  Future<void> _verileriGetir() async {
    final liste = await UretimDBHelper().getUretimler();

    final Map<String, List<UretimModel>> gruplu = {};
    for (var u in liste) {
      final tarih = u.kayitZamani.split(' ').first;
      gruplu.putIfAbsent(tarih, () => []).add(u);
    }

    setState(() {
      grupluUretimler = gruplu;
    });
  }

  Future<void> _onayliSil(VoidCallback onSil) async {
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
    if (sonuc == true) onSil();
  }

  void _sil(UretimModel model) async {
    await UretimDBHelper().deleteUretim(model.id!);
    _verileriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ana Sayfa')),
      drawer: const AppDrawer(),
      body: grupluUretimler.isEmpty
          ? const Center(child: Text('Kayıt yok'))
          : ListView(
        children: grupluUretimler.entries.map((entry) {
          final tarih = entry.key;
          final liste = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey[300],
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.parse(tarih)),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...liste.map((r) => UretimCard(
                model: r,
                onEdit: () {
                  // TODO: Düzenleme ekranına yönlendir
                },
                onDelete: () => _onayliSil(() => _sil(r)),
                onShare: () {
                  // TODO: PDF/Excel aktarımı
                },
              )),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReferansSecimPage()),
          ).then((_) {
            _verileriGetir();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Üretim'),
      ),
    );
  }
}