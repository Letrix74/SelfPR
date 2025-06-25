import 'package:flutter/material.dart';
import '../models/uretim_model.dart';

class UretimCard extends StatelessWidget {
  final UretimModel model;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const UretimCard({
    super.key,
    required this.model,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(model.referansAdi),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Maça: ${model.macaSayisi}'),
            Text('Üretim: ${model.uretimAdedi}'),
            Text('Vulkanize: ${model.vulkanizeKodu}'),
            Text('Eboş: ${model.ebosKodu}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
            IconButton(icon: const Icon(Icons.share), onPressed: onShare),
          ],
        ),
      ),
    );
  }
}