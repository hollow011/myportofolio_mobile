import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});
  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '', _description = '', _tech = '', _url = '', _image = '';
  bool _submitting = false;

  String? _required(String? value, {int? max}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Kolom ini wajib diisi.';
    if (max != null && text.runes.length > max) {
      return 'Maksimal $max karakter.';
    }
    return null;
  }

  String? _validateUrl(String? value, {bool optional = false, int max = 200}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty && optional) return null;
    final uri = Uri.tryParse(text);
    if (text.length > max ||
        text.contains(RegExp(r'\s')) ||
        uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      return 'Masukkan URL http/https yang valid (maksimal $max karakter).';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = context.read<AuthState>().token;
      if (token == null) return;
      _formKey.currentState!.save();
      final saved = await context.read<ApiClient>().createProject(
        Project(
          title: _title,
          description: _description,
          techStack: _tech,
          projectUrl: _url,
          projectImageUrl: _image,
        ),
        token: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proyek berhasil disimpan!'),
          scrollable: true,
          content: Text(
            'Title: ${saved.title}\nDescription: ${saved.description}\nTech Stack: ${saved.techStack}\nProject URL: ${saved.projectUrl}\nProject Image URL: ${saved.projectImageUrl}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) _formKey.currentState!.reset();
    } catch (error) {
      if (!mounted) return;
      if (error is ApiException && error.statusCode == 401) {
        try {
          await context.read<AuthState>().logout();
        } catch (_) {}
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is ApiException ? error.message : 'Respons server tidak valid. Periksa daftar sebelum mencoba lagi.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add Project Form')),
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
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _required(value, max: 255),
              onSaved: (value) => _title = value!.trim(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: _required,
              onSaved: (value) => _description = value!.trim(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tech Stack',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _required(value, max: 255),
              onSaved: (value) => _tech = value!.trim(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Project URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: _validateUrl,
              onSaved: (value) => _url = value!.trim(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Project Image URL (Optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: (value) =>
                  _validateUrl(value, optional: true, max: 500),
              onSaved: (value) => _image = value!.trim(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: Text(_submitting ? 'Menyimpan…' : 'Save'),
            ),
          ],
        ),
      ),
    ),
  );
}
