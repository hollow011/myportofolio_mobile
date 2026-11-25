import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
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

  bool _submitting = false;

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = context.read<AuthState>().token;
      if (token == null) return;
      _formKey.currentState!.save();
      final saved = await context.read<ApiClient>().createEducation(
        Education(
          institution: _institution,
          degree: _degree!,
          fieldOfStudy: _fieldOfStudy,
        ),
        token: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: const Text('Edukasi berhasil disimpan'),
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Institusi: ${saved.institution}'),
              Text('Jenjang Pendidikan: ${saved.degreeDisplay}'),
              Text('Bidang Studi: ${saved.fieldOfStudy}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog),
              child: const Text('Lihat Edukasi'),
            ),
          ],
        ),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EducationListScreen()),
        );
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
      if (error.statusCode == 401) {
        context.read<AuthState>().clearSession();
        await ensureLoggedIn(context);
      }
    } on FormatException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Respons server tidak valid. Periksa daftar edukasi.',
            ),
          ),
        );
      }
    } on TypeError {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data edukasi tidak sesuai. Periksa daftar edukasi.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

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
                onPressed: _submitting ? null : _submit,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
