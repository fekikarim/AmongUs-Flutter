import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/network/amongus_api_client.dart';
import '../../core/storage/suspect_storage.dart';
import '../emergency_meeting/emergency_meeting_screen.dart';
import '../home/avatar_option.dart';
import '../player_details/player_details_screen.dart';
import 'home_provider.dart';

class GameRoomScreen extends StatefulWidget {
  const GameRoomScreen({
    super.key,
    required this.username,
    required this.avatar,
    required this.accessToken,
  });

  final String username;
  final AvatarOption avatar;
  final String accessToken;

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  final _suspects = SuspectStorage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => HomeProvider(
        apiClient: AmongUsApiClient(),
        accessToken: widget.accessToken,
      )..loadRoom(),
      child: _GameRoomView(username: widget.username, suspects: _suspects),
    );
  }
}

class _GameRoomView extends StatelessWidget {
  const _GameRoomView({required this.username, required this.suspects});

  final String username;
  final SuspectStorage suspects;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Room'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<HomeProvider>().toggleVotesSort();
            },
            icon: Icon(
              provider.sortOrder == VotesSortOrder.asc
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EmergencyMeetingScreen(),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.exclamationmark_circle_fill),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: Hive.box('suspects').listenable(),
        builder: (context, _, __) {
          if (provider.isLoading && provider.players.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.players.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Failed to load room',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<HomeProvider>().loadRoom(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                child: Text(
                  'Hello $username',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Players',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      provider.sortOrder == VotesSortOrder.asc
                          ? 'Votes (asc)'
                          : 'Votes (desc)',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<UnmodifiableListView<PlayerDto>>(
                  stream: provider.playersStream,
                  initialData: provider.players,
                  builder: (context, snapshot) {
                    final players = snapshot.data ?? provider.players;

                    return ListView.separated(
                      itemCount: players.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, thickness: 1),
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final avatar = AvatarOption.fromApiValue(player.avatar);
                        final isSuspect = suspects.isSuspect(player.username);

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PlayerDetailsScreen(
                                  username: player.username,
                                  avatar: avatar,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 86,
                                  height: 86,
                                  child: Image.asset(
                                    avatar.assetPath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        player.username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isSuspect
                                            ? '${avatar.displayName} • Suspect • Votes: ${player.votes}'
                                            : '${avatar.displayName} • Votes: ${player.votes}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
