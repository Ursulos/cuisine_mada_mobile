import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cuisine_mada/core/constants/app_colors.dart';
import 'package:cuisine_mada/core/constants/app_dimensions.dart';
import 'package:cuisine_mada/presentation/pages/auth/cgu_page.dart';
import 'package:cuisine_mada/presentation/pages/main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedCgu = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedCgu) {
      setState(() => _errorMessage =
          'Vous devez accepter les CGU pour continuer.');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await credential.user?.updateDisplayName(
        _nameController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _errorMessage = 'Cet email est déjà utilisé.';
            break;
          case 'invalid-email':
            _errorMessage = 'Email invalide.';
            break;
          case 'weak-password':
            _errorMessage = 'Mot de passe trop faible.';
            break;
          default:
            _errorMessage = 'Erreur d\'inscription. Réessayez.';
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
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
        title: Text(
          'Créer un compte',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 32),
                _buildForm(),
                const SizedBox(height: 20),
                _buildCguCheckbox(context),
                const SizedBox(height: 16),
                if (_errorMessage != null) _buildError(),
                const SizedBox(height: 16),
                _buildRegisterButton(),
                const SizedBox(height: 40),
              ],
            ),
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
          'Bienvenue ! 👋',
          style: GoogleFonts.nunito(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        Text(
          'Créez votre compte pour des recettes\npersonnalisées chaque jour',
          style: GoogleFonts.nunito(
            fontSize: 14,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('👤 Votre prénom'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _nameController,
          style: GoogleFonts.nunito(
              fontSize: 14, color: AppColors.textDark),
          validator: (v) =>
              v!.isEmpty ? 'Prénom obligatoire' : null,
          decoration: InputDecoration(
            hintText: 'Ex : Haja',
            hintStyle: GoogleFonts.nunito(
                fontSize: 14, color: AppColors.textLight),
            prefixIcon: const Icon(Icons.person_rounded,
                color: AppColors.textLight),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('📧 Adresse email'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.nunito(
              fontSize: 14, color: AppColors.textDark),
          validator: (v) {
            if (v!.isEmpty) return 'Email obligatoire';
            if (!v.contains('@')) return 'Email invalide';
            return null;
          },
          decoration: InputDecoration(
            hintText: 'votre@email.com',
            hintStyle: GoogleFonts.nunito(
                fontSize: 14, color: AppColors.textLight),
            prefixIcon: const Icon(Icons.email_rounded,
                color: AppColors.textLight),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('🔒 Mot de passe'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: GoogleFonts.nunito(
              fontSize: 14, color: AppColors.textDark),
          validator: (v) {
            if (v!.isEmpty) return 'Mot de passe obligatoire';
            if (v.length < 6) return 'Minimum 6 caractères';
            return null;
          },
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: GoogleFonts.nunito(
                fontSize: 14, color: AppColors.textLight),
            prefixIcon: const Icon(Icons.lock_rounded,
                color: AppColors.textLight),
            suffixIcon: GestureDetector(
              onTap: () => setState(
                  () => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: AppColors.textLight,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('🔒 Confirmer le mot de passe'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirm,
          style: GoogleFonts.nunito(
              fontSize: 14, color: AppColors.textDark),
          validator: (v) {
            if (v!.isEmpty) return 'Confirmation obligatoire';
            if (v != _passwordController.text)
              return 'Les mots de passe ne correspondent pas';
            return null;
          },
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: GoogleFonts.nunito(
                fontSize: 14, color: AppColors.textLight),
            prefixIcon: const Icon(Icons.lock_rounded,
                color: AppColors.textLight),
            suffixIcon: GestureDetector(
              onTap: () => setState(
                  () => _obscureConfirm = !_obscureConfirm),
              child: Icon(
                _obscureConfirm
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: AppColors.textLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCguCheckbox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _acceptedCgu
            ? AppColors.secondaryLight
            : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: _acceptedCgu
              ? AppColors.secondaryMid
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () =>
                setState(() => _acceptedCgu = !_acceptedCgu),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _acceptedCgu
                    ? AppColors.secondary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _acceptedCgu
                      ? AppColors.secondary
                      : AppColors.textLight,
                  width: 1.5,
                ),
              ),
              child: _acceptedCgu
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'J\'ai lu et j\'accepte les '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CguPage()),
                      ),
                      child: Text(
                        'Conditions Générales d\'Utilisation',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                      text:
                          ' et la politique de confidentialité de Cuisine Mada.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: const Color(0xFFEF9A9A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_rounded,
              color: Color(0xFFE53935), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: const Color(0xFFC62828),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Créer mon compte',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}