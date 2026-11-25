import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/screens/education_detail_screen.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationListScreen extends StatefulWidget {
  const EducationListScreen({super.key});
  @override
  State<EducationListScreen> createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  late Future<List<Education>> _entries;
  @override
  void initState() {
    super.initState();
    _entries = context.read<ApiClient>().getEducation();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getEducation();
    setState(() {
      _entries = future;
    });
    // FutureBuilder renders the failure; refresh callbacks must not leak it.
    try {
      await future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Daftar Edukasi'),
      actions: [
        IconButton(
          onPressed: _reload,
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
        ),
      ],
    ),
    drawer: const LeftDrawer(),
    body: FutureBuilder<List<Education>>(
      future: _entries,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    snapshot.error is ApiException
                        ? (snapshot.error as ApiException).message
                        : 'Respons edukasi tidak valid.',
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: _reload,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        final entries = snapshot.data ?? const <Education>[];
        return RefreshIndicator(
          onRefresh: _reload,
          child: entries.isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: const Center(
                        child: Text('Belum ada riwayat pendidikan.'),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Card(
                      child: ListTile(
                        title: Text(entry.institution),
                        subtitle: Text(
                          '${entry.degreeDisplay}\n${entry.fieldOfStudy}',
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EducationDetailScreen(entry: entry),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    ),
  );
}
