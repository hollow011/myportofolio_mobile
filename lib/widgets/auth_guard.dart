import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
  return loggedIn ?? false;
}

Future<void> logOut(BuildContext context) async {
  final auth = context.read<AuthState>();
  String message = 'Anda belum login.';
  if (auth.isLoggedIn) {
    try {
      await auth.logout();
      message = 'Logout berhasil.';
    } catch (_) {
      message = 'Sesi lokal ditutup; token server belum dapat dicabut. Coba login dan logout lagi saat online.';
    }
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
