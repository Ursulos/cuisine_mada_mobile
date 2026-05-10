import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cuisine_mada/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await seedIngredients();
  print('✅ Tous les ingrédients ont été ajoutés !');
}

Future<void> seedIngredients() async {
  final firestore = FirebaseFirestore.instance;

  // Récupère toutes les recettes
  final recipes = await firestore
      .collection('recipes')
      .where('isValidated', isEqualTo: true)
      .get();

  for (final doc in recipes.docs) {
    final name = doc.data()['name'] as String;
    print('Ajout des ingrédients pour : $name');

    final ingredients = _getIngredients(name);
    for (final ing in ingredients) {
      await doc.reference.collection('ingredients').add(ing);
    }
  }
}

Map<String, dynamic> _ingredient(
    String name, int quantity, String unit, int pricePerUnit) {
  return {
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'pricePerUnit': pricePerUnit,
  };
}

List<Map<String, dynamic>> _getIngredients(String recipeName) {
  switch (recipeName) {
    case 'Henakisoa sy anana':
      return [
        _ingredient('Riz (vary)', 400, 'g', 5),
        _ingredient('Viande de porc (henakisoa)', 300, 'g', 20),
        _ingredient('Brèdes mafanes (anana)', 200, 'g', 8),
        _ingredient('Oignon', 2, 'pièce(s)', 500),
        _ingredient('Tomate', 2, 'pièce(s)', 400),
        _ingredient('Huile', 30, 'ml', 10),
        _ingredient('Sel, poivre', 1, 'pièce(s)', 200),
      ];

    case 'Romazava':
      return [
        _ingredient('Riz (vary)', 500, 'g', 5),
        _ingredient('Viande de bœuf', 400, 'g', 25),
        _ingredient('Brèdes mafanes', 300, 'g', 8),
        _ingredient('Brèdes morelle', 200, 'g', 6),
        _ingredient('Oignon', 3, 'pièce(s)', 500),
        _ingredient('Tomate', 3, 'pièce(s)', 400),
        _ingredient('Gingembre', 1, 'pièce(s)', 300),
        _ingredient('Huile', 30, 'ml', 10),
        _ingredient('Sel, poivre', 1, 'pièce(s)', 200),
      ];

    case 'Lasopy sy anana':
      return [
        _ingredient('Riz (vary)', 300, 'g', 5),
        _ingredient('Brèdes mafanes', 400, 'g', 8),
        _ingredient('Oignon', 2, 'pièce(s)', 500),
        _ingredient('Tomate', 2, 'pièce(s)', 400),
        _ingredient('Ail', 3, 'pièce(s)', 200),
        _ingredient('Huile', 20, 'ml', 10),
        _ingredient('Sel, poivre', 1, 'pièce(s)', 200),
      ];

    case 'Lasopy akoho':
      return [
        _ingredient('Poulet (akoho)', 500, 'g', 18),
        _ingredient('Riz (vary)', 400, 'g', 5),
        _ingredient('Oignon', 2, 'pièce(s)', 500),
        _ingredient('Tomate', 2, 'pièce(s)', 400),
        _ingredient('Gingembre', 1, 'pièce(s)', 300),
        _ingredient('Ail', 3, 'pièce(s)', 200),
        _ingredient('Huile', 30, 'ml', 10),
        _ingredient('Sel, poivre', 1, 'pièce(s)', 200),
      ];

    case 'Ravitoto sy voanjobory':
      return [
        _ingredient('Feuilles de manioc (ravitoto)', 400, 'g', 4),
        _ingredient('Haricots (voanjobory)', 300, 'g', 6),
        _ingredient('Riz (vary)', 400, 'g', 5),
        _ingredient('Oignon', 2, 'pièce(s)', 500),
        _ingredient('Ail', 3, 'pièce(s)', 200),
        _ingredient('Huile de coco', 30, 'ml', 15),
        _ingredient('Sel', 1, 'pièce(s)', 100),
      ];

    default:
      return [];
  }
}