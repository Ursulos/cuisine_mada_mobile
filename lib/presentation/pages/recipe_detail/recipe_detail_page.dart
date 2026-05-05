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
          child: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textDark),
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

  Widget _buildMetaRow() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _metaChip(Icons.monetization_on_rounded, '12 000 Ar',
                  AppColors.primaryLight, AppColors.primary),
              const SizedBox(width: 8),
              _metaChip(Icons.people_rounded, '4 personnes',
                  AppColors.secondaryLight, AppColors.secondary),
              const SizedBox(width: 8),
              _metaChip(Icons.timer_rounded, '30 min',
                  const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
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
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      color: AppColors.divider,
    );
  }

  Widget _buildIngredients() {
    final ingredients = [
      {'name': 'Riz (vary)', 'qty': '400 g', 'price': '2 000 Ar'},
      {'name': 'Viande de porc', 'qty': '300 g', 'price': '6 000 Ar'},
      {'name': 'Brèdes mafanes (anana)', 'qty': '200 g', 'price': '1 500 Ar'},
      {'name': 'Oignon', 'qty': '2 pcs', 'price': '500 Ar'},
      {'name': 'Tomate', 'qty': '2 pcs', 'price': '800 Ar'},
      {'name': 'Huile, sel, poivre', 'qty': '', 'price': '1 200 Ar'},
    ];

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
          const SizedBox(height: 12),
          ...ingredients.map((ing) => _ingredientRow(
                ing['name']!,
                ing['qty']!,
                ing['price']!,
              )),
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
                  'Total estimé',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  '12 000 Ar',
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

  Widget _ingredientRow(String name, String qty, String price) {
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
              name,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: AppColors.textDark,
              ),
            ),
          ),
          if (qty.isNotEmpty)
            Text(
              qty,
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          const SizedBox(width: 12),
          Text(
            price,
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