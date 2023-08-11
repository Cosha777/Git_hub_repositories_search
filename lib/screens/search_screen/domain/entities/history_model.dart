class HistoryModel {
  final String query;

  HistoryModel({required this.query});

  HistoryModel.fromJson(Map<String, dynamic> json)
      : query = json['query'];

  Map<String, dynamic> toJson() => {
        'query': query,
      };
}
