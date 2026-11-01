import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/global_sports_service.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  final GlobalSportsService _service = GlobalSportsService();
  String _selectedSport = 'All';
  String _selectedDate = 'Today';
  String _selectedStatusTab = 'All'; // 'All', 'LIVE', 'Finished'
  String? _selectedCountry;

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
    var matches = _service.matches;

    // Filter by sport
    if (_selectedSport != 'All') {
      matches = matches.where((m) => m.sport == _selectedSport).toList();
    }

    // Filter by date
    matches = matches.where((m) => m.date == _selectedDate).toList();

    // Filter by country
    if (_selectedCountry != null && _selectedCountry != 'All') {
      matches = matches.where((m) => m.country == _selectedCountry).toList();
    }

    // Filter by status tab
    if (_selectedStatusTab == 'LIVE') {
      matches = matches.where((m) => m.isLive).toList();
    } else if (_selectedStatusTab == 'Finished') {
      matches = matches.where((m) => m.status.toLowerCase().contains('finish') || (!m.isLive && m.score != null)).toList();
    }

    // Group matches by tournament
    final Map<String, List<GlobalMatch>> grouped = {};
    for (final m in matches) {
      final key = '${m.country} • ${m.tournament}';
      grouped.putIfAbsent(key, () => []).add(m);
    }

    final countries = ['All', ..._service.matches.map((m) => m.country).toSet()];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Global Sports',
              style: TextStyle(color: AppTheme.textLight, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Updated: ${_service.lastUpdated.hour.toString().padLeft(2, '0')}:${_service.lastUpdated.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: AppTheme.border, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Demo',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _service.refresh,
        color: AppTheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sport chips
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
              const SizedBox(height: 12),

              // Date ribbon
              Row(
                children: ['Yesterday', 'Today', 'Tomorrow'].map((d) {
                  final isSel = _selectedDate == d;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        onPressed: () => setState(() => _selectedDate = d),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSel ? AppTheme.primary : AppTheme.darkNav,
                          side: BorderSide(color: isSel ? AppTheme.accentGreen : Colors.transparent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                          minimumSize: const Size(0, 40),
                        ),
                        child: Text(
                          d,
                          style: TextStyle(
                            color: isSel ? Colors.white : AppTheme.border,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Country and Status row
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.darkNav,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCountry ?? 'All',
                          dropdownColor: AppTheme.darkNav,
                          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.border),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          onChanged: (val) => setState(() => _selectedCountry = val),
                          items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: ['All', 'LIVE', 'Finished'].map((st) {
                        final isSel = _selectedStatusTab == st;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedStatusTab = st),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? AppTheme.primary : AppTheme.darkNav,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  st,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : AppTheme.border,
                                    fontSize: 11,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Matches list grouped by tournament
              if (grouped.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.darkNav,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.sports_rounded, size: 48, color: AppTheme.border),
                      SizedBox(height: 12),
                      Text(
                        'No matches found for the selected filters.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.border, fontSize: 14),
                      ),
                    ],
                  ),
                )
              else
                ...grouped.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.border,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            color: AppTheme.textMain,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      ...entry.value.map((match) => _buildMatchCard(context, match)),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, GlobalMatch match) {
    final isFav = _service.favMatchIds.contains(match.id);
    return Card(
      color: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: () => _showMatchDetails(context, match),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        match.sport == 'Football'
                            ? Icons.sports_soccer
                            : match.sport == 'Basketball'
                                ? Icons.sports_basketball
                                : Icons.sports_tennis,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        match.time,
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (match.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            match.status,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        )
                      else
                        Text(
                          match.status,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _service.toggleFavoriteMatch(match.id),
                        child: Icon(
                          isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: isFav ? AppTheme.accentGreen : AppTheme.textSecondary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: AppTheme.border, height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.participantA,
                          style: const TextStyle(
                            color: AppTheme.textMain,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          match.participantB,
                          style: const TextStyle(
                            color: AppTheme.textMain,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (match.score != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        match.score!,
                        style: const TextStyle(
                          color: AppTheme.textMain,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMatchDetails(BuildContext context, GlobalMatch match) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${match.sport} • ${match.tournament}',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: match.isLive ? Colors.red.shade600 : AppTheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      match.status,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${match.participantA} vs ${match.participantB}',
                style: const TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (match.score != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Score: ${match.score}',
                  style: const TextStyle(color: AppTheme.primary, fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Venue: ${match.venue}',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const Divider(color: AppTheme.border, height: 24),
              const Text('Match Statistics', style: TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (match.stats.isEmpty)
                const Text('No detailed statistics recorded yet.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13))
              else ...[
                if (match.stats.containsKey('goals')) ...[
                  const Text('Goals:', style: TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.w600, fontSize: 13)),
                  for (final g in (match.stats['goals'] as List))
                    Text('• $g', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 6),
                ],
                if (match.stats.containsKey('cards')) ...[
                  const Text('Cards:', style: TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.w600, fontSize: 13)),
                  for (final c in (match.stats['cards'] as List))
                    Text('• $c', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 6),
                ],
                if (match.stats.containsKey('quarters')) ...[
                  Text('Quarters: ${match.stats['quarters']}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  if (match.stats.containsKey('top_scorers'))
                    Text('Leaders: ${match.stats['top_scorers']}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
                if (match.stats.containsKey('sets')) ...[
                  Text('Sets: ${match.stats['sets']}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  if (match.stats.containsKey('aces'))
                    Text('Aces: ${match.stats['aces']}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
