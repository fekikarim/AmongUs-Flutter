import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../home/avatar_option.dart';

class EmergencyMeetingScreen extends StatelessWidget {
  const EmergencyMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency meeting'), centerTitle: true),
      body: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: Hive.box('suspects').listenable(),
        builder: (context, box, _) {
          final suspects = box.values
              .whereType<Map>()
              .map((e) => e.cast<String, dynamic>())
              .toList();

          if (suspects.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Suspects',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('No suspects yet.'),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = switch (constraints.maxWidth) {
                < 420 => 2,
                < 720 => 3,
                _ => 4,
              };

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Suspects',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final data = suspects[index];
                        final username = (data['username'] as String?) ?? '';
                        final avatarApi = (data['avatar'] as String?) ?? 'red';
                        final avatar = AvatarOption.fromApiValue(avatarApi);

                        return Column(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.asset(
                                  avatar.assetPath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              username,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        );
                      }, childCount: suspects.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 28,
                        crossAxisSpacing: 28,
                        childAspectRatio: 0.80,
                      ),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
