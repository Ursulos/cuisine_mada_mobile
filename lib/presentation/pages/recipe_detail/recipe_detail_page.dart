import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cuisine_mada/core/constants/app_colors.dart';
import 'package:cuisine_mada/core/constants/app_dimensions.dart';
import 'package:cuisine_mada/data/datasources/remote/recipe_remote_datasource.dart';
import 'package:cuisine_mada/data/models/recipe_model.dart';

class RecipeDetailPage extends StatefulWidget {
  final RecipeModel? recipe;

  const RecipeDetailPage({super.key, this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool _isFavorite = false;
  int _persons = 4;
  List<Map<String, dynamic>> _ingredients = [];
  bool _loadingIngredients = true;

  final RecipeRemoteDatasource _datasource = RecipeRemoteDatasource();

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _persons = widget.recipe!.basePersons;
      _loadIngredients();
    }
  }

  Future<void> _loadIngredients() async {
    if (widget.recipe == null) return;
    setState(() => _loadingIngredients = true);
    try {
      final ingredients =
          await _datasource.getIngredients(widget.recipe!.id);
      setState(() {
        _ingredients = ingredients;
        _loadingIngredients = false;
      });
    } catch (e) {
      setState(() => _loadingIngredients = false);
    }
  }

  double get _totalPrice {
    if (_ingredients.isEmpty) {
      return ((widget.recipe?.estimatedCost ?? 0) / 
          (widget.recipe?.basePersons ?? 4)) * _persons;
    }
    double total = 0;
    for (final ing in _ingredients) {
      final qty = (ing['quantity'] as num).toDouble();
      final price = (ing['pricePerUnit'] as num).toDouble();
      final unit = ing['unit'] as String;
      double basePrice = 0;
      if (unit == 'kg' || unit == 'litre') {
        basePrice = (qty / 1000) * price;
      } else {
        basePrice = qty * price;
      }
      total += basePrice;
    }
    final basePersons = widget.recipe?.basePersons ?? 4;
    return (total / basePersons) * _persons;
  }

  double _ingredientPrice(Map<String, dynamic> ing) {
    final qty = (ing['quantity'] as num).toDouble();
    final price = (ing['pricePerUnit'] as num).toDouble();
    final unit = ing['unit'] as String;
    double basePrice = 0;
    if (unit == 'kg' || unit == 'litre') {
      basePrice = (qty / 1000) * price;
    } else {
      basePrice = qty * price;
    }
    final basePersons = widget.recipe?.basePersons ?? 4;
    return (basePrice / basePersons) * _persons;
  }

  double _adjustedQty(Map<String, dynamic> ing) {
    final qty = (ing['quantity'] as num).toDouble();
    final basePersons = widget.recipe?.basePersons ?? 4;
    return (qty / basePersons) * _persons;
  }

  List<String> _parseSteps() {
    final steps = widget.recipe?.steps ?? '';
    if (steps.isEmpty) return [];
    return steps
        .split(RegExp(r'\n|(?=\d+\.)'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, recipe),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPersonsSelector(),
                _buildMetaRow(recipe),
                _buildDivider(),
                _buildIngredients(),
                _buildDivider(),
                _buildSteps(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildAppBar(BuildContext context, RecipeModel? recipe) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textDark,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() => _isFavorite = !_isFavorite),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavorite ? Colors.red : AppColors.textDark,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image ou gradient
            recipe?.imageUrl != null && recipe!.imageUrl.isNotEmpty
                ? Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildGradientBg(),
                  )
                : _buildGradientBg(),
            // Overlay sombre
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe?.name ?? 'Recette',
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    recipe?.description ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                  if (recipe?.createdByUserName != null &&
                      recipe!.createdByUserName!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '✍️ Créé par ${recipe.createdByUserName}',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBg() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFC8712A), Color(0xFF5C3010)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          widget.recipe?.emoji ?? '🍛',
          style: const TextStyle(fontSize: 100),
        ),
      ),
    );
  }

  Widget _buildPersonsSelector() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingL),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.primaryMid),
      ),
      child: Row(
        children: [
          const Text('👥', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Nombre de personnes',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_persons > 1) setState(() => _persons--);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryMid),
              ),
              child: const Icon(
                Icons.remove_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '$_persons',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_persons < 20) setState(() => _persons++);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(RecipeModel? recipe) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _metaChip(
                Icons.monetization_on_rounded,
                '${_totalPrice.toStringAsFixed(0)} Ar',
                AppColors.primaryLight,
                AppColors.primary,
              ),
              const SizedBox(width: 8),
              _metaChip(
                Icons.timer_rounded,
                '${recipe?.preparationMinutes ?? 0} min',
                const Color(0xFFE3F2FD),
                const Color(0xFF1565C0),
              ),
              if (recipe?.isHalal == true) ...[
                const SizedBox(width: 8),
                _metaChip(
                  Icons.verified_rounded,
                  'Halal',
                  AppColors.secondaryLight,
                  AppColors.secondary,
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          if (recipe != null)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: recipe.tags
                  .map((tag) => _tag(
                        tag,
                        AppColors.tagEasyBg,
                        AppColors.tagEasyText,
                      ))
                  .toList(),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String label, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
      ),
      color: AppColors.divider,
    );
  }

  Widget _buildIngredients() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🧂 Ingrédients',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Quantités ajustées pour $_persons personne${_persons > 1 ? 's' : ''}',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          if (_loadingIngredients)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          else if (_ingredients.isEmpty)
            Text(
              'Aucun ingrédient disponible',
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            )
          else
            ..._ingredients.map((ing) => _ingredientRow(ing)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total pour $_persons pers.',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  '${_totalPrice.toStringAsFixed(0)} Ar',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ingredientRow(Map<String, dynamic> ing) {
    final adjustedQty = _adjustedQty(ing);
    final price = _ingredientPrice(ing);
    final unit = ing['unit'] as String;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ing['name'] ?? '',
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: AppColors.textDark,
              ),
            ),
          ),
          Text(
            unit == 'g' && adjustedQty >= 1000
                ? '${(adjustedQty / 1000).toStringAsFixed(1)} kg'
                : '${adjustedQty.toStringAsFixed(unit == 'g' ? 0 : 1)} $unit',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${price.toStringAsFixed(0)} Ar',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps() {
    final steps = _parseSteps();

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👨‍🍳 Préparation',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          if (steps.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Text(
                widget.recipe?.description ?? 'Préparation non disponible.',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.6,
                ),
              ),
            )
          else
            ...steps.asMap().entries.map(
                  (e) => _stepItem(e.key + 1, e.value),
                ),
        ],
      ),
    );
  }

  Widget _stepItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: AppColors.textDark,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✅ ${widget.recipe?.name ?? 'Recette'} ajoutée à votre historique !',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
                ),
                backgroundColor: AppColors.secondary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          child: Text(
            '🍳 Je cuisine cette recette !',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}