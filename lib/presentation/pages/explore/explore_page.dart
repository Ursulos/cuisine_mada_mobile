import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cuisine_mada/core/constants/app_colors.dart';
import 'package:cuisine_mada/core/constants/app_dimensions.dart';
import 'package:cuisine_mada/presentation/pages/recipe_detail/recipe_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _activeFilter = 'Tout';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _filters = [
    {'label': 'Tout', 'icon': '🍽️'},
    {'label': 'Halal', 'icon': '☪️'},
    {'label': 'Économique', 'icon': '💰'},
    {'label': 'Rapide', 'icon': '⚡'},
    {'label': 'Végétarien', 'icon': '🥦'},
    {'label': 'Familial', 'icon': '👨‍👩‍👧'},
  ];

  final List<Map<String, dynamic>> _recipes = [
    {
      'emoji': '🍛',
      'name': 'Henakisoa sy anana',
      'sub': 'Riz · Porc · Brèdes',
      'price': '12 000 Ar',
      'persons': '4 pers.',
      'time': '30 min',
      'tags': ['Familial'],
      'isFavorite': true,
      'creator': null,
    },
    {
      'emoji': '🥣',
      'name': 'Lasopy sy anana',
      'sub': 'Soupe · Légumes · Rapide',
      'price': '8 500 Ar',
      'persons': '6 pers.',
      'time': '20 min',
      'tags': ['Rapide', 'Économique'],
      'isFavorite': false,
      'creator': 'Haja',
    },
    {
      'emoji': '🍲',
      'name': 'Romazava',
      'sub': 'Viande · Brèdes · Traditionnel',
      'price': '10 000 Ar',
      'persons': '5 pers.',
      'time': '45 min',
      'tags': ['Familial'],
      'isFavorite': false,
      'creator': null,
    },
    {
      'emoji': '🐔',
      'name': 'Lasopy akoho',
      'sub': 'Soupe de poulet · Halal',
      'price': '9 000 Ar',
      'persons': '4 pers.',
      'time': '25 min',
      'tags': ['Halal', 'Rapide'],
      'isFavorite': false,
      'creator': 'Fatouma',
    },
    {
      'emoji': '🫘',
      'name': 'Ravitoto sy voanjobory',
      'sub': 'Manioc · Haricots · Végétarien',
      'price': '6 500 Ar',
      'persons': '4 pers.',
      'time': '40 min',
      'tags': ['Végétarien', 'Économique'],
      'isFavorite': false,
      'creator': null,
    },
    {
      'emoji': '🥩',
      'name': 'Akoho sy voanio',
      'sub': 'Poulet · Coco · Halal',
      'price': '14 000 Ar',
      'persons': '4 pers.',
      'time': '50 min',
      'tags': ['Halal', 'Familial'],
      'isFavorite': false,
      'creator': 'Aminata',
    },
    {
      'emoji': '🍃',
      'name': 'Vary amin\'anana',
      'sub': 'Riz · Légumes · Simple',
      'price': '4 000 Ar',
      'persons': '3 pers.',
      'time': '15 min',
      'tags': ['Végétarien', 'Rapide', 'Économique'],
      'isFavorite': false,
      'creator': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredRecipes {
    return _recipes.where((recipe) {
      final matchesFilter = _activeFilter == 'Tout' ||
          (recipe['tags'] as List).contains(_activeFilter);
      final matchesSearch = _searchQuery.isEmpty ||
          recipe['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          recipe['sub']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            _buildFilters(),
            _buildResultCount(),
            Expanded(child: _buildRecipeList()),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explorer 🔍',
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: 'Rechercher une recette...',
                hintStyle: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textLight,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textLight,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
        ),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isActive = _activeFilter == filter['label'];
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = filter['label']!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                '${filter['icon']} ${filter['label']}',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.white : AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultCount() {
    final count = _filteredRecipes.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingL,
        12,
        AppDimensions.paddingL,
        4,
      ),
      child: Text(
        '$count recette${count > 1 ? 's' : ''} trouvée${count > 1 ? 's' : ''}',
        style: GoogleFonts.nunito(
          fontSize: 12,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRecipeList() {
    final recipes = _filteredRecipes;
    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🍽️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Aucune recette trouvée',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              'Essayez un autre filtre',
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
      itemCount: recipes.length,
      itemBuilder: (context, index) => _buildRecipeRow(context, recipes[index]),
    );
  }

  Widget _buildRecipeRow(BuildContext context, Map<String, dynamic> recipe) {
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
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  recipe['emoji'],
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['name'],
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    recipe['sub'],
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        recipe['price'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${recipe['persons']} · ${recipe['time']}',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (recipe['creator'] != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '✍️ Créé par ${recipe['creator']}',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              recipe['isFavorite']
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: recipe['isFavorite'] ? Colors.red : AppColors.textLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}