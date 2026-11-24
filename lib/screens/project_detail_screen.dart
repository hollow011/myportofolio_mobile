import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(project.title)),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('Teknologi: ${project.techStack}'),
          const SizedBox(height: 12),
          Text(project.description),
          const SizedBox(height: 12),
          SelectableText('URL Proyek: ${project.projectUrl}'),
          if (project.projectImageUrl.isNotEmpty) ...[
            const SizedBox(height: 16),
            Image.network(
              project.projectImageUrl,
              semanticLabel: 'Gambar ${project.title}',
              errorBuilder: (_, error, stack) =>
                  const Text('Gambar tidak dapat dimuat.'),
            ),
          ],
        ],
      ),
    ),
  );
}
