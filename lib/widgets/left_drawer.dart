import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final pageContext = Scaffold.of(context).context;
    final loggedIn = context.watch<AuthState>().isLoggedIn;
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                pageContext,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () async {
              Navigator.pop(context);
              if (!await ensureLoggedIn(pageContext) || !pageContext.mounted) {
                return;
              }
              Navigator.pushReplacement(
                pageContext,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Education'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                pageContext,
                MaterialPageRoute(builder: (_) => const EducationListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Education'),
            onTap: () async {
              Navigator.pop(context);
              if (!await ensureLoggedIn(pageContext) || !pageContext.mounted) {
                return;
              }
              Navigator.pushReplacement(
                pageContext,
                MaterialPageRoute(
                  builder: (context) => const EducationFormPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Projects'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                pageContext,
                MaterialPageRoute(builder: (_) => const ProjectListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(loggedIn ? Icons.logout : Icons.login),
            title: Text(loggedIn ? 'Logout' : 'Login'),
            onTap: () async {
              Navigator.pop(context);
              if (loggedIn) {
                await logOut(pageContext);
              } else {
                await ensureLoggedIn(pageContext);
              }
            },
          ),
        ],
      ),
    );
  }
}
