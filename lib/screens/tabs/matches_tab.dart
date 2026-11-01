import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});
  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  String _sport = 'Football';
  String _filter = 'All';

  final List<Map<String, dynamic>> _items = [
    {'sport': 'Football', 'tour': 'Champions League', 'a': 'Real Madrid', 'b': 'Bayern Munich', 'score': '2 : 2', 'status': 'LIVE 74\'', 'live': true},
    {'sport': 'Football', 'tour': 'Premier League', 'a': 'Arsenal', 'b': 'Chelsea', 'score': '3 : 1', 'status': 'Full Time', 'live': false},
    {'sport': 'Basketball', 'tour': 'NBA Regular Season', 'a': 'Boston Celtics', 'b': 'LA Lakers', 'score': '112 : 108', 'status': 'Q4 02:15', 'live': true},
    {'sport': 'Tennis', 'tour': 'Roland Garros', 'a': 'C. Alcaraz', 'b': 'J. Sinner', 'score': '6:3, 6:4', 'status': 'Set 3', 'live': true},
  ];

  @override
  Widget build(BuildContext context) {
    final list = _items.where((e) => e['sport'] == _sport).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Global Matches', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.accentGreen, borderRadius: BorderRadius.circular(8)),
                child: const Text('Worldwide', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sport chips
          Row(
            children: ['Football', 'Basketball', 'Tennis'].map((s) {
              final sel = _sport == s;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(s),
                  selected: sel,
                  onSelected: (_) => setState(() => _sport = s),
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.darkNav,
                  labelStyle: TextStyle(color: sel ? Colors.white : AppTheme.border, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ...list.map((m) => Card(
            color: AppTheme.surfaceCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m['tour'], style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      if (m['live'])
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                          child: Text(m['status'], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        )
                      else
                        Text(m['status'], style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(m['a'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: AppTheme.lightBg, borderRadius: BorderRadius.circular(8)),
                        child: Text(m['score'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                      ),
                      Expanded(child: Text(m['b'], textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain))),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
