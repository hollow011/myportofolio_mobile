import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({required this.entry, super.key});
  final Education entry;

  @override
  Widget build(BuildContext context) {
    final fields = {
      'Institusi': entry.institution,
      'Jenjang': entry.degreeDisplay,
      'Kode jenjang': entry.degree,
      'Bidang studi': entry.fieldOfStudy,
      'Deskripsi': entry.description,
      'Situs': entry.website,
      'Sedang ditempuh': entry.isCurrent ? 'Ya' : 'Tidak',
      'Dibuat': entry.createdAt?.toLocal().toString() ?? '',
      'Jumlah bintang': entry.starCount.toString(),
      'Ditandai pada tampilan publik': entry.isStarred ? 'Ya' : 'Tidak',
      'Pemberi bintang': entry.starredByNames,
      'ID': entry.id ?? '',
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Edukasi')),
      body: ListView(
        children: [
          for (final field in fields.entries)
            ListTile(
              title: Text(field.key),
              subtitle: SelectableText(field.value.isEmpty ? '—' : field.value),
            ),
        ],
      ),
    );
  }
}
