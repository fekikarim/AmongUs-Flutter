import 'package:flutter/material.dart';

import '../../core/network/amongus_api_client.dart';
import '../game_room/game_room_screen.dart';
import 'avatar_option.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _usernameController = TextEditingController();
  final _api = AmongUsApiClient();

  AvatarOption _selectedAvatar = AvatarOption.red;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _onStartPressed() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username is required')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final token = await _api.addPlayer(
        avatar: _selectedAvatar.apiValue,
        username: username,
      );

      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GameRoomScreen(
            username: username,
            avatar: _selectedAvatar,
            accessToken: token,
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Something went wrong')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  _selectedAvatar.assetPath,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Custom your Avatar',
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Choose Username',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Choose your skin',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.black87),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  for (final avatar in AvatarOption.values)
                    _ColorButton(
                      color: avatar.swatchColor,
                      isSelected: avatar == _selectedAvatar,
                      onTap: () => setState(() => _selectedAvatar = avatar),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _onStartPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: _isSubmitting
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
                      : const Text('Start', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.black12,
            width: 2,
          ),
        ),
      ),
    );
  }
}
