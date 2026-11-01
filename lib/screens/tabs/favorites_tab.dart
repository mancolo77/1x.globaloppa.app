import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/global_sports_service.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  final GlobalSportsService _service = GlobalSportsService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favMatches = _service.matches.where((m) => _service.favMatchIds.contains(m.id)).toList();
    final favTours = _service.tournaments.where((t) => _service.favTournamentIds.contains(t.id)).toList();
    final favParticipants = _service.favParticipantNames.toList();

    final bool isEmpty = favMatches.isEmpty && favTours.isEmpty && favParticipants.isEmpty;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Favorites', style: TextStyle(color: AppTheme.textLight, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.darkNav,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.star_border_rounded, size: 54, color: AppTheme.border),
                    SizedBox(height: 16),
                    Text(
                      'No Favorites Yet',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add matches, tournaments or participants to quickly follow them from this tab.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.border, fontSize: 13),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bookmarked Matches
                  if (favMatches.isNotEmpty) ...[
                    const Text('Saved Matches', style: TextStyle(color: AppTheme.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...favMatches.map((m) => Card(
                          color: AppTheme.surfaceCard,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${m.sport} • ${m.tournament}',
                                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${m.participantA} vs ${m.participantB}',
                                        style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${m.date} at ${m.time} • ${m.status}',
                                        style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.star_rounded, color: AppTheme.accentGreen),
                                  onPressed: () => _service.toggleFavoriteMatch(m.id),
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 16),
                  ],

                  // Saved Tournaments
                  if (favTours.isNotEmpty) ...[
                    const Text('Saved Tournaments', style: TextStyle(color: AppTheme.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...favTours.map((t) => Card(
                          color: AppTheme.surfaceCard,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const Icon(Icons.emoji_events, color: AppTheme.primary),
                            title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                            subtitle: Text('${t.country} • ${t.sport}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            trailing: IconButton(
                              icon: const Icon(Icons.star_rounded, color: AppTheme.accentGreen),
                              onPressed: () => _service.toggleFavoriteTournament(t.id),
                            ),
                          ),
                        )),
                    const SizedBox(height: 16),
                  ],

                  // Saved Participants / Teams / Players
                  if (favParticipants.isNotEmpty) ...[
                    const Text('Followed Teams & Players', style: TextStyle(color: AppTheme.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: favParticipants.map((name) {
                        return Chip(
                          backgroundColor: AppTheme.darkNav,
                          label: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          deleteIcon: const Icon(Icons.close, size: 16, color: AppTheme.border),
                          onDeleted: () => _service.toggleFavoriteParticipant(name),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
