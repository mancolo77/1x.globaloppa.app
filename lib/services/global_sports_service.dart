import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalMatch {
  final String id;
  final String sport; // 'Football', 'Basketball', 'Tennis'
  final String country;
  final String tournament;
  final String participantA;
  final String participantB;
  final String date; // 'Today', 'Tomorrow', 'Yesterday'
  final String time;
  final String? score;
  final bool isLive;
  final String status;
  final String venue;
  final Map<String, dynamic> stats; // sport specific stats

  const GlobalMatch({
    required this.id,
    required this.sport,
    required this.country,
    required this.tournament,
    required this.participantA,
    required this.participantB,
    required this.date,
    required this.time,
    this.score,
    this.isLive = false,
    required this.status,
    required this.venue,
    this.stats = const {},
  });
}

class TournamentInfo {
  final String id;
  final String name;
  final String sport;
  final String country;
  final List<Map<String, dynamic>> standings;

  const TournamentInfo({
    required this.id,
    required this.name,
    required this.sport,
    required this.country,
    required this.standings,
  });
}

class GlobalSportsService with ChangeNotifier {
  static final GlobalSportsService _instance = GlobalSportsService._internal();
  factory GlobalSportsService() => _instance;
  GlobalSportsService._internal();

  final Set<String> _favMatchIds = {'gm_1'};
  final Set<String> _favTournamentIds = {'tour_epl'};
  final Set<String> _favParticipantNames = {'Real Madrid', 'C. Alcaraz'};
  DateTime _lastUpdated = DateTime.now();

  Set<String> get favMatchIds => Set.unmodifiable(_favMatchIds);
  Set<String> get favTournamentIds => Set.unmodifiable(_favTournamentIds);
  Set<String> get favParticipantNames => Set.unmodifiable(_favParticipantNames);
  DateTime get lastUpdated => _lastUpdated;

  final List<TournamentInfo> tournaments = const [
    TournamentInfo(
      id: 'tour_epl',
      name: 'Premier League',
      sport: 'Football',
      country: 'England',
      standings: [
        {'rank': 1, 'team': 'Manchester City', 'mp': 10, 'pts': 25},
        {'rank': 2, 'team': 'Liverpool', 'mp': 10, 'pts': 24},
        {'rank': 3, 'team': 'Arsenal', 'mp': 10, 'pts': 22},
        {'rank': 4, 'team': 'Chelsea', 'mp': 10, 'pts': 19},
      ],
    ),
    TournamentInfo(
      id: 'tour_laliga',
      name: 'La Liga',
      sport: 'Football',
      country: 'Spain',
      standings: [
        {'rank': 1, 'team': 'Barcelona', 'mp': 11, 'pts': 30},
        {'rank': 2, 'team': 'Real Madrid', 'mp': 11, 'pts': 24},
        {'rank': 3, 'team': 'Atletico Madrid', 'mp': 11, 'pts': 20},
      ],
    ),
    TournamentInfo(
      id: 'tour_nba',
      name: 'NBA',
      sport: 'Basketball',
      country: 'USA',
      standings: [
        {'rank': 1, 'team': 'Boston Celtics', 'mp': 6, 'pts': 11},
        {'rank': 2, 'team': 'Golden State Warriors', 'mp': 6, 'pts': 10},
        {'rank': 3, 'team': 'LA Lakers', 'mp': 6, 'pts': 9},
      ],
    ),
    TournamentInfo(
      id: 'tour_atp',
      name: 'ATP Masters Tour',
      sport: 'Tennis',
      country: 'International',
      standings: [
        {'rank': 1, 'team': 'J. Sinner', 'mp': 42, 'pts': 11920},
        {'rank': 2, 'team': 'C. Alcaraz', 'mp': 38, 'pts': 7120},
        {'rank': 3, 'team': 'A. Zverev', 'mp': 40, 'pts': 6795},
      ],
    ),
  ];

  final List<GlobalMatch> matches = const [
    // Football
    GlobalMatch(
      id: 'gm_1',
      sport: 'Football',
      country: 'England',
      tournament: 'Premier League',
      participantA: 'Arsenal',
      participantB: 'Chelsea',
      date: 'Today',
      time: '17:30',
      score: '2 : 1',
      isLive: true,
      status: 'In-Play (65\')',
      venue: 'Emirates Stadium (London)',
      stats: {
        'goals': ['B. Saka 21\'', 'C. Palmer 43\'', 'K. Havertz 58\''],
        'cards': ['M. Caicedo (Yellow 34\')', 'D. Rice (Yellow 61\')'],
      },
    ),
    GlobalMatch(
      id: 'gm_2',
      sport: 'Football',
      country: 'Spain',
      tournament: 'La Liga',
      participantA: 'Real Madrid',
      participantB: 'Valencia',
      date: 'Today',
      time: '21:00',
      score: null,
      isLive: false,
      status: 'Scheduled',
      venue: 'Santiago Bernabéu (Madrid)',
      stats: {},
    ),
    GlobalMatch(
      id: 'gm_3',
      sport: 'Football',
      country: 'England',
      tournament: 'Premier League',
      participantA: 'Liverpool',
      participantB: 'Brighton',
      date: 'Yesterday',
      time: '15:00',
      score: '2 : 1',
      isLive: false,
      status: 'Finished',
      venue: 'Anfield (Liverpool)',
      stats: {
        'goals': ['C. Gakpo 69\'', 'M. Salah 72\'', 'F. Kadioglu 14\''],
        'cards': ['A. Mac Allister (Yellow 45\')'],
      },
    ),

    // Basketball
    GlobalMatch(
      id: 'gm_4',
      sport: 'Basketball',
      country: 'USA',
      tournament: 'NBA',
      participantA: 'LA Lakers',
      participantB: 'Golden State Warriors',
      date: 'Today',
      time: '19:30',
      score: '114 : 108',
      isLive: true,
      status: 'Q4 (02:15)',
      venue: 'Crypto.com Arena (Los Angeles)',
      stats: {
        'quarters': 'Q1: 28-26 | Q2: 31-29 | Q3: 26-27 | Q4: 29-26',
        'top_scorers': 'L. James (28 pts) • S. Curry (32 pts)',
      },
    ),
    GlobalMatch(
      id: 'gm_5',
      sport: 'Basketball',
      country: 'USA',
      tournament: 'NBA',
      participantA: 'Boston Celtics',
      participantB: 'Milwaukee Bucks',
      date: 'Tomorrow',
      time: '02:00',
      score: null,
      isLive: false,
      status: 'Upcoming',
      venue: 'TD Garden (Boston)',
      stats: {},
    ),

    // Tennis
    GlobalMatch(
      id: 'gm_6',
      sport: 'Tennis',
      country: 'International',
      tournament: 'ATP Masters Tour',
      participantA: 'C. Alcaraz',
      participantB: 'D. Medvedev',
      date: 'Today',
      time: '14:00',
      score: '6-4, 4-6, 7-6',
      isLive: false,
      status: 'Finished',
      venue: 'Court Central (Paris)',
      stats: {
        'sets': 'Set 1: 6-4 | Set 2: 4-6 | Set 3: 7-6 (7-4)',
        'aces': 'Alcaraz: 9 • Medvedev: 14',
      },
    ),
    GlobalMatch(
      id: 'gm_7',
      sport: 'Tennis',
      country: 'International',
      tournament: 'ATP Masters Tour',
      participantA: 'J. Sinner',
      participantB: 'A. Zverev',
      date: 'Tomorrow',
      time: '16:00',
      score: null,
      isLive: false,
      status: 'Upcoming',
      venue: 'Court Central (Paris)',
      stats: {},
    ),
  ];

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favM = prefs.getStringList('fav_matches_global');
      if (favM != null) {
        _favMatchIds.clear();
        _favMatchIds.addAll(favM);
      }
      final favT = prefs.getStringList('fav_tours_global');
      if (favT != null) {
        _favTournamentIds.clear();
        _favTournamentIds.addAll(favT);
      }
      final favP = prefs.getStringList('fav_part_global');
      if (favP != null) {
        _favParticipantNames.clear();
        _favParticipantNames.addAll(favP);
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('fav_matches_global', _favMatchIds.toList());
      await prefs.setStringList('fav_tours_global', _favTournamentIds.toList());
      await prefs.setStringList('fav_part_global', _favParticipantNames.toList());
    } catch (_) {}
  }

  void toggleFavoriteMatch(String id) {
    if (_favMatchIds.contains(id)) {
      _favMatchIds.remove(id);
    } else {
      _favMatchIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void toggleFavoriteTournament(String id) {
    if (_favTournamentIds.contains(id)) {
      _favTournamentIds.remove(id);
    } else {
      _favTournamentIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void toggleFavoriteParticipant(String name) {
    if (_favParticipantNames.contains(name)) {
      _favParticipantNames.remove(name);
    } else {
      _favParticipantNames.add(name);
    }
    _save();
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _lastUpdated = DateTime.now();
    notifyListeners();
  }
}

