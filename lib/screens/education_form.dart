import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _institution = '';
  String _fieldOfStudy = '';
  String? _degree;

  // Values match Education.DEGREE_CHOICES in the Django portfolio.
  static const _degrees = {
    'secondary': 'Secondary school',
    'diploma': 'Diploma',
    'bachelor': "Bachelor's degree",
    'master': "Master's degree",
    'doctorate': 'Doctorate',
    'other': 'Other',
  };

  String? _validateText(String? value, String label) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label wajib diisi.';
    if (text.runes.length > 255) return '$label maksimal 255 karakter.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Edukasi'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Institusi',
                  helperText: 'Maksimal 255 karakter',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) => _validateText(value, 'Institusi'),
                onSaved: (value) => _institution = value!.trim(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Jenjang Pendidikan',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Pilih jenjang'),
                isExpanded: true,
                items: _degrees.entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: (value) => _degree = value,
                validator: (value) => _degrees.containsKey(value)
                    ? null
                    : 'Pilih jenjang pendidikan.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Bidang Studi',
                  helperText: 'Maksimal 255 karakter',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _validateText(value, 'Bidang studi'),
                onSaved: (value) => _fieldOfStudy = value!.trim(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Ringkasan Edukasi'),
                      scrollable: true,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Institusi: $_institution'),
                          Text('Jenjang Pendidikan: ${_degrees[_degree]}'),
                          Text('Bidang Studi: $_fieldOfStudy'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
