import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuisine_mada/data/models/recipe_model.dart';

class RecipeRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RecipeModel>> getAllRecipes() async {
    final snapshot = await _firestore
        .collection('recipes')
        .where('isValidated', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => RecipeModel.fromFirestore(doc))
        .toList();
  }

  Future<List<RecipeModel>> getRecipesByFilter({
    bool? isHalal,
    bool? isVegetarian,
    String? tag,
  }) async {
    Query query = _firestore
        .collection('recipes')
        .where('isValidated', isEqualTo: true);

    if (isHalal == true) {
      query = query.where('isHalal', isEqualTo: true);
    }
    if (isVegetarian == true) {
      query = query.where('isVegetarian', isEqualTo: true);
    }

    final snapshot = await query.get();
    List<RecipeModel> recipes = snapshot.docs
        .map((doc) => RecipeModel.fromFirestore(doc))
        .toList();

    if (tag != null && tag != 'Tout') {
      recipes = recipes
          .where((r) => r.tags.contains(tag))
          .toList();
    }

    return recipes;
  }

  Future<void> submitRecipe(RecipeModel recipe) async {
    await _firestore.collection('recipes').add(recipe.toFirestore()
      ..['isValidated'] = false);
  }

  Stream<List<RecipeModel>> watchAllRecipes() {
    return _firestore
        .collection('recipes')
        .where('isValidated', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecipeModel.fromFirestore(doc))
            .toList());
  }
}