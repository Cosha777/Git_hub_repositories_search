class FavoriteModel {
  final int id;
  final String title;

  FavoriteModel({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': title,
      };

  FavoriteModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        title = json['repoName'];
}
