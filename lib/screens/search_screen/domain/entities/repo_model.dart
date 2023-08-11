class RepoModel {
  final int id;
  final String repoName;
  bool isFavorite = false;

  RepoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        repoName = json['name'];

  RepoModel({
    required this.id,
    required this.repoName,
    required this.isFavorite,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'repoName': repoName,
        'isFavorite': isFavorite ? 0 : 1,
      };
}
