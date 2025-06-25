import 'package:flutter/material.dart';
import '../database/referans_db_helper.dart';
import '../models/referans_model.dart';
import 'app_drawer.dart';

class ReferanslarPage extends StatefulWidget {
  const ReferanslarPage({super.key});

  @override
  State<ReferanslarPage> createState() => _ReferanslarPageState();
}

class _ReferanslarPageState extends State<ReferanslarPage> {
  List<ReferansModel> _tumReferanslar = [];
  final TextEditingController _aramaController = TextEditingController();

  Future<void> _verileriGetir([String? arama]) async {
    final veriler = await ReferansDBHelper().getReferanslar(arama: arama);
    setState(() {
      _tumReferanslar = veriler;
    });
  }

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referanslar'),
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
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: TextField(
              controller: _aramaController,
              decoration: InputDecoration(
                hintText: 'Referans, Vulkanize veya Eboş ara',
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
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.referansAdi,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 90,
                              child: Text(
                                'Vulkanize:',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(child: Text(r.vulkanizeKodu)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 90,
                              child: Text(
                                'Eboş:',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Expanded(child: Text(r.ebosKodu)),
                          ],
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
    );
  }
}