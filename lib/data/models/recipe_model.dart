import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuisine_mada/domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.emoji,
    required super.preparationMinutes,
    required super.basePersons,
    required super.estimatedCost,
    required super.isHalal,
    required super.isVegetarian,
    required super.isValidated,
    required super.tags,
    super.createdByUserName,
    required super.averageRating,
  });

  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      emoji: data['emoji'] ?? '🍛',
      preparationMinutes: data['preparationMinutes'] ?? 0,
      basePersons: data['basePersons'] ?? 4,
      estimatedCost: data['estimatedCost'] ?? 0,
      isHalal: data['isHalal'] ?? false,
      isVegetarian: data['isVegetarian'] ?? false,
      isValidated: data['isValidated'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      createdByUserName: data['createdByUserName'] == ''
          ? null
          : data['createdByUserName'],
      averageRating: double.tryParse(
              data['averageRating']?.toString() ?? '0') ??
          0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'emoji': emoji,
      'preparationMinutes': preparationMinutes,
      'basePersons': basePersons,
      'estimatedCost': estimatedCost,
      'isHalal': isHalal,
      'isVegetarian': isVegetarian,
      'isValidated': isValidated,
      'tags': tags,
      'createdByUserName': createdByUserName ?? '',
      'averageRating': averageRating.toString(),
    };
  }
}