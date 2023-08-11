import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:git_hub_repositories/screens/search_screen/domain/entities/repo_model.dart';

abstract class RemoteDataService {
  Future<List<RepoModel>> getRepoByName(String name, int page);
}

class RemoteDataSourceHTTP implements RemoteDataService {
  @override
  Future<List<RepoModel>> getRepoByName(String name, int page) => _getRepos(
      'https://api.github.com/search/repositories?q=$name&page=$page&per_page=10');

  Future<List<RepoModel>> _getRepos(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      var results = jsonDecode(response.body);
      return (results['items'] as List)
          .map((json) => RepoModel.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Server problem...\nor check your internet connection';
    }
  }
}
