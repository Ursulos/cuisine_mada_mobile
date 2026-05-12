class Recipe {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String imageUrl;
  final int preparationMinutes;
  final int cookMinutes;
  final int basePersons;
  final int estimatedCost;
  final bool isHalal;
  final bool isVegetarian;
  final bool isValidated;
  final List<String> tags;
  final String? createdByUserName;
  final double averageRating;
  final String steps;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.imageUrl,
    required this.preparationMinutes,
    required this.cookMinutes,
    required this.basePersons,
    required this.estimatedCost,
    required this.isHalal,
    required this.isVegetarian,
    required this.isValidated,
    required this.tags,
    this.createdByUserName,
    required this.averageRating,
    required this.steps,
  });
}