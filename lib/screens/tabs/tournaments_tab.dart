import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TournamentsTab extends StatelessWidget {
  const TournamentsTab({super.key});

  final List<Map<String, String>> tours = const [
    {'name': 'UEFA Champions League', 'country': 'Europe', 'teams': '32 Clubs'},
    {'name': 'Premier League', 'country': 'England', 'teams': '20 Clubs'},
    {'name': 'NBA Championship', 'country': 'USA', 'teams': '30 Teams'},
    {'name': 'Roland Garros Grand Slam', 'country': 'France', 'teams': '128 Players'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tournaments', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
          const SizedBox(height: 16),
          ...tours.map((t) => Card(
            color: AppTheme.surfaceCard,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.emoji_events_rounded, color: AppTheme.primary, size: 28),
              title: Text(t['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
              subtitle: Text('${t['country']} • ${t['teams']}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
            ),
          )),
        ],
      ),
    );
  }
}
