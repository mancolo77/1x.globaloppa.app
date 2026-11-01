import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/global_sports_service.dart';

class TournamentsTab extends StatefulWidget {
  const TournamentsTab({super.key});

  @override
  State<TournamentsTab> createState() => _TournamentsTabState();
}

class _TournamentsTabState extends State<TournamentsTab> {
  final GlobalSportsService _service = GlobalSportsService();
  String _searchQuery = '';
  String _selectedSport = 'All';

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
    var tours = _service.tournaments;

    if (_selectedSport != 'All') {
      tours = tours.where((t) => t.sport == _selectedSport).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      tours = tours.where((t) => t.name.toLowerCase().contains(q) || t.country.toLowerCase().contains(q)).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Tournaments', style: TextStyle(color: AppTheme.textLight, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search tournament or country...',
                hintStyle: const TextStyle(color: AppTheme.border),
                prefixIcon: const Icon(Icons.search, color: AppTheme.border),
                filled: true,
                fillColor: AppTheme.darkNav,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 12),

            // Sports chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Football', 'Basketball', 'Tennis'].map((sport) {
                  final isSel = _selectedSport == sport;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(sport),
                      selected: isSel,
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.darkNav,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : AppTheme.border,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _selectedSport = sport),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            if (tours.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.darkNav,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.emoji_events_outlined, size: 48, color: AppTheme.border),
                    SizedBox(height: 12),
                    Text(
                      'No tournaments match your search.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.border, fontSize: 14),
                    ),
                  ],
                ),
              )
            else
              ...tours.map((t) {
                final isFav = _service.favTournamentIds.contains(t.id);
                return Card(
                  color: AppTheme.surfaceCard,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                  elevation: 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    onTap: () => _showTournamentDetails(context, t),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.lightBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              t.sport == 'Football'
                                  ? Icons.sports_soccer
                                  : t.sport == 'Basketball'
                                      ? Icons.sports_basketball
                                      : Icons.sports_tennis,
                              color: AppTheme.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.name,
                                  style: const TextStyle(
                                    color: AppTheme.textMain,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${t.country} • ${t.sport}',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: isFav ? AppTheme.accentGreen : AppTheme.textSecondary,
                            ),
                            onPressed: () => _service.toggleFavoriteTournament(t.id),
                          ),
                          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  void _showTournamentDetails(BuildContext context, TournamentInfo t) {
    final matches = _service.matches.where((m) => m.tournament == t.name).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          t.name,
                          style: const TextStyle(color: AppTheme.textMain, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          t.country,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Standings table
                  const Text('Standings', style: TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: const BoxDecoration(
                            color: AppTheme.border,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 28, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                              Expanded(child: Text('Participant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                              SizedBox(width: 40, child: Text('MP', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                              SizedBox(width: 40, child: Text('PTS', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            ],
                          ),
                        ),
                        ...t.standings.map((s) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 28,
                                    child: Text('${s['rank']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ),
                                  Expanded(
                                    child: Text(s['team'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textMain)),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Text('${s['mp']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Text('${s['pts']}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primary)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text('Matches & Schedule', style: TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (matches.isEmpty)
                    const Text('No fixtures recorded for this tournament.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13))
                  else
                    ...matches.map((m) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.lightBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${m.participantA} vs ${m.participantB}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textMain)),
                                    Text('${m.date} • ${m.time} • ${m.venue}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                  ],
                                ),
                              ),
                              Text(m.score ?? m.status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primary)),
                            ],
                          ),
                        )),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
