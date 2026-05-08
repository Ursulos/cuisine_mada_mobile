class Recipe {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int preparationMinutes;
  final int basePersons;
  final int estimatedCost;
  final bool isHalal;
  final bool isVegetarian;
  final bool isValidated;
  final List<String> tags;
  final String? createdByUserName;
  final double averageRating;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.preparationMinutes,
    required this.basePersons,
    required this.estimatedCost,
    required this.isHalal,
    required this.isVegetarian,
    required this.isValidated,
    required this.tags,
    this.createdByUserName,
    required this.averageRating,
  });
}