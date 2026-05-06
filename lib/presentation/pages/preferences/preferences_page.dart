import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cuisine_mada/core/constants/app_colors.dart';
import 'package:cuisine_mada/core/constants/app_dimensions.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  double _budget = 12000;
  int _persons = 4;
  bool _isHalal = false;
  bool _isVegetarian = false;
  final TextEditingController _excludeController = TextEditingController();
  final List<String> _excludedIngredients = ['Voanjobory', 'Sakamalaho'];

  @override
  void dispose() {
    _excludeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildBudgetCard(),
              const SizedBox(height: 14),
              _buildPersonsCard(),
              const SizedBox(height: 14),
              _buildDietCard(),
              const SizedBox(height: 14),
              _buildExcludeCard(),
              const SizedBox(height: 24),
              _buildGenerateButton(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Préférences 👤',
          style: GoogleFonts.nunito(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        Text(
          'Ajustez vos critères pour des suggestions personnalisées',
          style: GoogleFonts.nunito(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('💵 Budget quotidien'),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_budget.toStringAsFixed(0)} ',
                style: GoogleFonts.nunito(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'Ar',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primaryLight,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.1),
            ),
            child: Slider(
              min: 3000,
              max: 50000,
              divisions: 94,
              value: _budget,
              onChanged: (val) => setState(() => _budget = val),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('3 000 Ar',
                  style: GoogleFonts.nunito(
                      fontSize: 11, color: AppColors.textLight)),
              Text('50 000 Ar',
                  style: GoogleFonts.nunito(
                      fontSize: 11, color: AppColors.textLight)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('👥 Nombre de personnes'),
          const SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (_persons > 1) setState(() => _persons--);
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryMid),
                  ),
                  child: const Icon(Icons.remove_rounded,
                      color: AppColors.primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '$_persons',
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_persons < 20) setState(() => _persons++);
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: AppColors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'personne${_persons > 1 ? 's' : ''}',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDietCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('🥗 Options alimentaires'),
          const SizedBox(height: 12),
          _toggleRow(
            icon: '☪️',
            label: 'Mode Halal uniquement',
            value: _isHalal,
            onChanged: (v) => setState(() => _isHalal = v),
          ),
          const SizedBox(height: 8),
          _toggleRow(
            icon: '🥦',
            label: 'Mode Végétarien uniquement',
            value: _isVegetarian,
            onChanged: (v) => setState(() => _isVegetarian = v),
          ),
        ],
      ),
    );
  }

  Widget _buildExcludeCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('🚫 Ingrédients à exclure'),
          const SizedBox(height: 4),
          Text(
            'Allergies, aversions, indisponibles',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _excludedIngredients
                .map((ing) => _excludeTag(ing))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _excludeController,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ajouter un ingrédient...',
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  final val = _excludeController.text.trim();
                  if (val.isNotEmpty &&
                      !_excludedIngredients.contains(val)) {
                    setState(() {
                      _excludedIngredients.add(val);
                      _excludeController.clear();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '+ Ajouter',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _excludeTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFC62828),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => setState(
                () => _excludedIngredients.remove(label)),
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✨ Nouvelle recette générée pour $_persons pers. — budget ${_budget.toStringAsFixed(0)} Ar !',
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
          '✨ Générer ma recette du jour',
          style: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  Widget _cardTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _toggleRow({
    required String icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
        ),
      ],
    );
  }
}