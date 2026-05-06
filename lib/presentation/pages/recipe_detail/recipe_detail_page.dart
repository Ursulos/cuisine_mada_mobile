import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cuisine_mada/core/constants/app_colors.dart';
import 'package:cuisine_mada/core/constants/app_dimensions.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool _isFavorite = false;
  int _persons = 4;

  // Prix de base pour 4 personnes
  final int _basePricePerPerson = 3000;
  final int _basePersons = 4;

  final List<Map<String, dynamic>> _ingredients = [
    {'name': 'Riz (vary)', 'qty': 400, 'unit': 'g', 'pricePerKg': 5000},
    {'name': 'Viande de porc', 'qty': 300, 'unit': 'g', 'pricePerKg': 20000},
    {'name': 'Brèdes mafanes', 'qty': 200, 'unit': 'g', 'pricePerKg': 7500},
    {'name': 'Oignon', 'qty': 2, 'unit': 'pièce(s)', 'pricePerKg': 250},
    {'name': 'Tomate', 'qty': 2, 'unit': 'pièce(s)', 'pricePerKg': 400},
    {'name': 'Huile, sel, poivre', 'qty': 1, 'unit': 'pièce(s)', 'pricePerKg': 1200},
  ];

  double get _totalPrice {
    return _basePricePerPerson * _persons.toDouble();
  }

  double _ingredientPrice(Map<String, dynamic> ing) {
    final baseQty = ing['qty'] as int;
    final pricePerUnit = ing['pricePerKg'] as int;
    final unit = ing['unit'] as String;
    double basePrice = 0;
    if (unit == 'g') {
      basePrice = (baseQty / 1000) * pricePerUnit;
    } else {
      basePrice = baseQty * pricePerUnit.toDouble();
    }
    return (basePrice / _basePersons) * _persons;
  }

  double _adjustedQty(Map<String, dynamic> ing) {
    final baseQty = ing['qty'] as int;
    return (baseQty / _basePersons) * _persons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPersonsSelector(),
                _buildMetaRow(),
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

  Widget _buildAppBar(BuildContext context) {
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
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFC8712A), Color(0xFF5C3010)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const Center(
              child: Text('🍛', style: TextStyle(fontSize: 100)),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Henakisoa sy anana',
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Riz · Viande · Légumes',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Widget _buildMetaRow() {
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
                '30 min',
                const Color(0xFFE3F2FD),
                const Color(0xFF1565C0),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: [
              _tag('Facile', AppColors.tagEasyBg, AppColors.tagEasyText),
              _tag('Économique', AppColors.tagEcoBg, AppColors.tagEcoText),
              _tag('Riche en saveurs', const Color(0xFFFCE4EC),
                  const Color(0xFF880E4F)),
            ],
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
              ing['name'],
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
    final steps = [
      'Faire revenir l\'oignon et la tomate dans l\'huile chaude jusqu\'à dorure.',
      'Ajouter la viande coupée en morceaux et faire sauter 10 minutes à feu vif.',
      'Incorporer les brèdes, couvrir et cuire à feu moyen pendant 10 minutes.',
      'Cuire le riz séparément à l\'eau salée. Servir chaud avec le ragoût.',
    ];

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
                  '✅ Ajouté à votre historique !',
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