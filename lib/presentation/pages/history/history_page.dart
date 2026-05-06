import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cuisine_mada/core/constants/app_colors.dart';
import 'package:cuisine_mada/core/constants/app_dimensions.dart';
import 'package:cuisine_mada/presentation/pages/recipe_detail/recipe_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedDay = 15;

  final List<Map<String, dynamic>> _days = [
    {'day': 'Lun', 'num': 12},
    {'day': 'Mar', 'num': 13},
    {'day': 'Mer', 'num': 14},
    {'day': 'Jeu', 'num': 15},
    {'day': 'Ven', 'num': 16},
    {'day': 'Sam', 'num': 17},
    {'day': 'Dim', 'num': 18},
  ];

  final List<Map<String, dynamic>> _history = [
    {
      'emoji': '🍲',
      'name': 'Romazava',
      'sub': 'Viande + Légumes',
      'price': '10 000 Ar',
      'persons': '5 pers.',
      'day': 15,
      'isFavorite': true,
    },
    {
      'emoji': '🍛',
      'name': 'Ravitoto sy henakisoa',
      'sub': 'Manioc + Porc',
      'price': '12 500 Ar',
      'persons': '4 pers.',
      'day': 14,
      'isFavorite': true,
    },
    {
      'emoji': '🐔',
      'name': 'Lasopy akoho',
      'sub': 'Soupe de poulet',
      'price': '8 000 Ar',
      'persons': '3 pers.',
      'day': 13,
      'isFavorite': false,
    },
    {
      'emoji': '🫘',
      'name': 'Voanjobory sy henakisoa',
      'sub': 'Haricots + Porc',
      'price': '9 500 Ar',
      'persons': '4 pers.',
      'day': 12,
      'isFavorite': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    if (_selectedDay == 0) return _history;
    return _history.where((h) => h['day'] == _selectedDay).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildCalendar(),
            _buildWeekLabel(),
            Expanded(child: _buildHistoryList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingL,
        AppDimensions.paddingL,
        AppDimensions.paddingL,
        12,
      ),
      child: Row(
        children: [
          Text(
            'Historique 📅',
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => _selectedDay = 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _selectedDay == 0
                    ? AppColors.primary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'Tout voir',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _selectedDay == 0
                      ? AppColors.white
                      : AppColors.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
        ),
        itemCount: _days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = _days[index];
          final isSelected = _selectedDay == day['num'];
          final hasRecipe = _history.any((h) => h['day'] == day['num']);
          return GestureDetector(
            onTap: () => setState(() => _selectedDay = day['num']),
            child: Container(
              width: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day['day'],
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.white.withOpacity(0.8)
                          : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day['num']}',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textDark,
                    ),
                  ),
                  if (hasRecipe)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeekLabel() {
    final count = _filteredHistory.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingL,
        12,
        AppDimensions.paddingL,
        4,
      ),
      child: Text(
        _selectedDay == 0
            ? 'Toute la semaine — $count repas'
            : '$count repas ce jour',
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    final items = _filteredHistory;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🍽️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Aucun repas ce jour',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              'Sélectionnez un autre jour',
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingL,
        8,
        AppDimensions.paddingL,
        80,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          _buildHistoryItem(context, items[index]),
    );
  }

  Widget _buildHistoryItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RecipeDetailPage()),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  item['emoji'],
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    item['sub'],
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        item['price'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['persons'],
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              item['isFavorite']
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: item['isFavorite'] ? Colors.red : AppColors.textLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}