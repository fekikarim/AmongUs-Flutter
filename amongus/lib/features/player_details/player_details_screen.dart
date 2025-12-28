 import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../core/storage/suspect_storage.dart';
import '../home/avatar_option.dart';

class PlayerDetailsScreen extends StatefulWidget {
  const PlayerDetailsScreen({
    super.key,
    required this.username,
    required this.avatar,
  });

  final String username;
  final AvatarOption avatar;

  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  final _suspects = SuspectStorage();

  bool _isSaving = false;

  Future<void> _showAlert({required String message}) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _markSuspect() async {
    if (_suspects.isSuspect(widget.username)) {
      await _showAlert(message: 'Player already Marked as suspect !');
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _suspects.markSuspect(
        username: widget.username,
        avatar: widget.avatar,
      );
      if (!mounted) return;
      await _showAlert(message: 'Player marked as suspect successfully !');
    } catch (_) {
      if (!mounted) return;
      await _showAlert(message: 'Failed to save suspect');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(widget.avatar.assetPath, fit: BoxFit.cover),
            ),
            const SizedBox(height: 14),
            const Text(
              'Lorem ipsum dolor sit er elit lamet, consectetur '
              'cilim adipisicing pecu, sed do eiusmod tempor '
              'incididunt ut labore et dolore magna aliqua. Ut enim '
              'ad minim veniam, quis nostrud exercitation ullamco '
              'laboris nisi ut aliquip ex ea commodo consequat. '
              'Duis aute irure dolor in reprehenderit in voluptate '
              'velit esse cillum dolore eu fugiat nulla pariatur. '
              'Excepteur sint occaecat cupidatat non proident, '
              'sunt in culpa qui officia deserunt mollit anim id est '
              'laborum. Nam liber te conscient to factor tum poen '
              'legum odioque civiuda.',
              style: TextStyle(height: 1.35),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _markSuspect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Suspect', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
