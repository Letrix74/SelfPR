import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text('Menü', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Referanslar'),
            onTap: () => Navigator.pushReplacementNamed(context, '/referanslar'),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Referans Düzenleme'),
            onTap: () => Navigator.pushReplacementNamed(context, '/referansDuzenle'),
          ),
        ],
      ),
    );
  }
}