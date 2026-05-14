import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cuisine_mada/core/constants/app_colors.dart';
import 'package:cuisine_mada/core/constants/app_dimensions.dart';

class CguPage extends StatelessWidget {
  const CguPage({super.key});

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
          'Conditions d\'utilisation',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSection(
              '1. Objet',
              'Les présentes Conditions Générales d\'Utilisation (CGU) régissent l\'utilisation de l\'application mobile Cuisine Mada. En utilisant cette application, vous acceptez pleinement et entièrement les présentes CGU.',
            ),
            _buildSection(
              '2. Description du service',
              'Cuisine Mada est une application mobile de suggestions de recettes malgaches personnalisées. Elle permet aux utilisateurs de découvrir des recettes adaptées à leur budget, leur nombre de personnes et leurs préférences alimentaires.',
            ),
            _buildSection(
              '3. Inscription et compte utilisateur',
              'Pour accéder à toutes les fonctionnalités, vous devez créer un compte avec une adresse email valide et un mot de passe sécurisé. Vous êtes responsable de la confidentialité de vos identifiants. Cuisine Mada ne peut être tenu responsable de tout accès non autorisé à votre compte.',
            ),
            _buildSection(
              '4. Données personnelles',
              'Cuisine Mada collecte uniquement les données nécessaires au fonctionnement de l\'application :\n\n• Adresse email et prénom (inscription)\n• Préférences alimentaires (budget, régime, ingrédients exclus)\n• Historique des recettes cuisinées\n\nCes données sont stockées de manière sécurisée via Firebase (Google) et ne sont jamais vendues à des tiers.',
            ),
            _buildSection(
              '5. Contenu communautaire',
              'Les utilisateurs peuvent soumettre des recettes. Tout contenu soumis doit :\n\n• Être original ou libre de droits\n• Ne pas contenir de contenu offensant ou illégal\n• Respecter les normes alimentaires en vigueur\n\nCuisine Mada se réserve le droit de refuser ou supprimer tout contenu ne respectant pas ces règles. Les recettes validées affichent le badge "Créé par [Nom]".',
            ),
            _buildSection(
              '6. Prix des ingrédients',
              'Les prix des ingrédients affichés sont donnés à titre indicatif et basés sur les prix du marché d\'Antananarivo. Ils peuvent varier selon les régions et les saisons. Cuisine Mada ne garantit pas l\'exactitude de ces prix.',
            ),
            _buildSection(
              '7. Propriété intellectuelle',
              'L\'application Cuisine Mada, son logo, son design et ses contenus originaux sont protégés par le droit de la propriété intellectuelle. Toute reproduction sans autorisation est interdite.',
            ),
            _buildSection(
              '8. Limitation de responsabilité',
              'Cuisine Mada ne peut être tenu responsable :\n\n• Des allergies ou intolérances alimentaires non signalées\n• Des variations de prix des ingrédients\n• Des problèmes de santé liés à la consommation des recettes\n\nNous vous recommandons de consulter un professionnel de santé en cas de régime alimentaire particulier.',
            ),
            _buildSection(
              '9. Halal et régimes alimentaires',
              'Les recettes marquées "Halal" sont identifiées sur la base des informations fournies par les contributeurs. Cuisine Mada ne peut garantir la certification Halal officielle de ces recettes. Les utilisateurs sont invités à vérifier les ingrédients selon leurs propres critères.',
            ),
            _buildSection(
              '10. Modification des CGU',
              'Cuisine Mada se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs seront informés par notification dans l\'application. La poursuite de l\'utilisation après modification vaut acceptation des nouvelles CGU.',
            ),
            _buildSection(
              '11. Droit applicable',
              'Les présentes CGU sont soumises au droit malgache. Tout litige sera soumis aux tribunaux compétents d\'Antananarivo, Madagascar.',
            ),
            _buildSection(
              '12. Contact',
              'Pour toute question concernant les présentes CGU ou vos données personnelles, contactez-nous à :\n\ncuisinemada.app@gmail.com',
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(color: AppColors.primaryMid),
              ),
              child: Row(
                children: [
                  const Text('📅', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dernière mise à jour : Mai 2026',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'J\'ai lu et compris',
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
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC8712A), Color(0xFF5C3010)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📋', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(
            'Conditions Générales\nd\'Utilisation',
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cuisine Mada — Application de recettes malgaches',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}