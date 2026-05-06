import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cuisine_mada/core/constants/app_colors.dart';
import 'package:cuisine_mada/core/constants/app_dimensions.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _timeController = TextEditingController();
  final _personsController = TextEditingController(text: '4');
  final _stepsController = TextEditingController();
  bool _isHalal = false;
  bool _isVegetarian = false;
  bool _isSubmitting = false;
  XFile? _imageFile;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  final List<String> _units = [
    'g', 'kg', 'ml', 'litre', 'pièce(s)', 'c.à.s', 'c.à.c'
  ];

  final List<Map<String, dynamic>> _ingredients = [
    {
      'name': TextEditingController(),
      'quantity': TextEditingController(),
      'unit': 'g',
      'pricePerUnit': TextEditingController(),
    },
    {
      'name': TextEditingController(),
      'quantity': TextEditingController(),
      'unit': 'g',
      'pricePerUnit': TextEditingController(),
    },
  ];

  double get _totalPrice {
    double total = 0;
    for (final ing in _ingredients) {
      final qty = double.tryParse(
              (ing['quantity'] as TextEditingController).text) ?? 0;
      final price = double.tryParse(
              (ing['pricePerUnit'] as TextEditingController).text) ?? 0;
      final unit = ing['unit'] as String;
      if (unit == 'kg' || unit == 'litre') {
        total += (qty / 1000) * price;
      } else {
        total += qty * price;
      }
    }
    return total;
  }

  int get _basePersons => int.tryParse(_personsController.text) ?? 4;

  double _priceForPersons(int persons) {
    if (_basePersons == 0) return 0;
    return (_totalPrice / _basePersons) * persons;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 85,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageFile = picked;
        _imageBytes = bytes;
      });
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ajouter une photo',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryMid),
                        ),
                        child: Column(
                          children: [
                            const Text('📷',
                                style: TextStyle(fontSize: 32)),
                            const SizedBox(height: 8),
                            Text(
                              'Caméra',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.secondaryMid.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text('🖼️',
                                style: TextStyle(fontSize: 32)),
                            const SizedBox(height: 8),
                            Text(
                              'Galerie',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
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

  void _addIngredient() {
    setState(() {
      _ingredients.add({
        'name': TextEditingController(),
        'quantity': TextEditingController(),
        'unit': 'g',
        'pricePerUnit': TextEditingController(),
      });
    });
  }

  void _removeIngredient(int index) {
    if (_ingredients.length > 1) {
      setState(() {
        (_ingredients[index]['name'] as TextEditingController).dispose();
        (_ingredients[index]['quantity'] as TextEditingController).dispose();
        (_ingredients[index]['pricePerUnit'] as TextEditingController).dispose();
        _ingredients.removeAt(index);
      });
    }
  }

  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isSubmitting = false);
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('✅', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                'Recette soumise !',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Votre recette sera vérifiée par notre équipe et publiée avec le badge "Créé par vous".',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Super !',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _timeController.dispose();
    _personsController.dispose();
    _stepsController.dispose();
    for (final ing in _ingredients) {
      (ing['name'] as TextEditingController).dispose();
      (ing['quantity'] as TextEditingController).dispose();
      (ing['pricePerUnit'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textDark),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajouter une recette',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            Text(
              'Sera validée par l\'admin avant publication',
              style: GoogleFonts.nunito(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPendingNote(),
              const SizedBox(height: 16),
              _buildPhotoSection(),
              const SizedBox(height: 20),
              _buildSectionTitle('📝 Informations générales'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nameController,
                label: 'Nom de la recette *',
                hint: 'Ex : Romazava traditionnel...',
                validator: (v) =>
                    v!.isEmpty ? 'Le nom est obligatoire' : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _descController,
                label: 'Description courte',
                hint: 'Ex : Viande + Brèdes mafanes...',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _timeController,
                      label: 'Temps (min) *',
                      hint: '30',
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v!.isEmpty ? 'Obligatoire' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _personsController,
                      label: 'Personnes de base *',
                      hint: '4',
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v!.isEmpty ? 'Obligatoire' : null,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('🥗 Options alimentaires'),
              const SizedBox(height: 12),
              _buildToggleRow(
                icon: '☪️',
                label: 'Recette Halal',
                value: _isHalal,
                onChanged: (v) => setState(() => _isHalal = v),
              ),
              const SizedBox(height: 8),
              _buildToggleRow(
                icon: '🥦',
                label: 'Recette Végétarienne',
                value: _isVegetarian,
                onChanged: (v) => setState(() => _isVegetarian = v),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('🧂 Ingrédients'),
              const SizedBox(height: 4),
              Text(
                'Prix par unité (ex: prix par kg, par pièce...)',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              ..._ingredients.asMap().entries.map(
                    (e) => _buildIngredientRow(e.key),
                  ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _addIngredient,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: AppColors.primaryMid),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_rounded,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Ajouter un ingrédient',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildPriceSummary(),
              const SizedBox(height: 20),
              _buildSectionTitle('👨‍🍳 Étapes de préparation'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _stepsController,
                label: 'Étapes *',
                hint:
                    '1. Faire revenir l\'oignon...\n2. Ajouter la viande...\n3. ...',
                maxLines: 6,
                validator: (v) =>
                    v!.isEmpty ? 'Les étapes sont obligatoires' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRecipe,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          '📤 Soumettre pour validation',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('📸 Photo de la recette'),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _showImagePicker,
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: _imageBytes != null
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ),
            child: _imageBytes != null
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusL),
                    child: Image.memory(
                      _imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📷',
                          style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 8),
                      Text(
                        'Appuyez pour ajouter une photo',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        'Caméra ou Galerie',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (_imageBytes != null) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() {
              _imageFile = null;
              _imageBytes = null;
            }),
            child: Row(
              children: [
                const Icon(Icons.close_rounded,
                    color: Color(0xFFE53935), size: 16),
                const SizedBox(width: 4),
                Text(
                  'Supprimer la photo',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: const Color(0xFFE53935),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.primaryMid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 Estimation du coût',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          _priceRow('Pour $_basePersons personnes (base)',
              '${_totalPrice.toStringAsFixed(0)} Ar'),
          _priceRow('Par personne',
              '${(_basePersons > 0 ? _totalPrice / _basePersons : 0).toStringAsFixed(0)} Ar'),
          const Divider(height: 16),
          _priceRow('Pour 2 personnes',
              '${_priceForPersons(2).toStringAsFixed(0)} Ar'),
          _priceRow('Pour 4 personnes',
              '${_priceForPersons(4).toStringAsFixed(0)} Ar'),
          _priceRow('Pour 6 personnes',
              '${_priceForPersons(6).toStringAsFixed(0)} Ar'),
          _priceRow('Pour 8 personnes',
              '${_priceForPersons(8).toStringAsFixed(0)} Ar'),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.nunito(
                  fontSize: 12, color: AppColors.textMuted)),
          Text(price,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              )),
        ],
      ),
    );
  }

  Widget _buildPendingNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: const Color(0xFFFFD54F)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⏳', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Les nouvelles recettes sont vérifiées avant publication. Un badge "Créé par [vous]" sera affiché.',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: const Color(0xFF795548),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          style: GoogleFonts.nunito(
            fontSize: 14,
            color: AppColors.textDark,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.nunito(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w700,
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
      ),
    );
  }

  Widget _buildIngredientRow(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ingredients[index]['name'],
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ingrédient...',
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _removeIngredient(index),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.remove_rounded,
                    color: Color(0xFFE53935),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ingredients[index]['quantity'],
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Quantité',
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _ingredients[index]['unit'],
                underline: const SizedBox(),
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
                items: _units
                    .map((u) => DropdownMenuItem(
                        value: u, child: Text(u)))
                    .toList(),
                onChanged: (val) {
                  setState(
                      () => _ingredients[index]['unit'] = val!);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _ingredients[index]['pricePerUnit'],
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Prix/unité Ar',
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}