import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/primary_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _displayName = TextEditingController();
  final _photoUrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final u = FirebaseAuth.instance.currentUser;
    _displayName.text = u?.displayName ?? '';
    _photoUrl.text = u?.photoURL ?? '';
  }

  @override
  void dispose() {
    _displayName.dispose();
    _photoUrl.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) return;
    setState(() => _loading = true);
    try {
      await u.updateDisplayName(_displayName.text.trim().isEmpty ? null : _displayName.text.trim());
      await u.updatePhotoURL(_photoUrl.text.trim().isEmpty ? null : _photoUrl.text.trim());
      await u.reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
      setState(() {});
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Update failed')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final u = FirebaseAuth.instance.currentUser;
    final email = u?.email ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('Hello, $email!', style: Theme.of(context).textTheme.titleMedium),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _displayName,
                  decoration: const InputDecoration(labelText: 'Display Name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _photoUrl,
                  decoration: const InputDecoration(labelText: 'Photo URL'),
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: 'Update Profile', onPressed: _update, loading: _loading),
                const SizedBox(height: 12),
                OutlinedButton(onPressed: _logout, child: const Text('Logout')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




