import 'package:git_hub_repositories/data_bases/favorite_repos_database.dart';
import 'package:git_hub_repositories/screens/favorite_screen/domain/entities/favorite_model.dart';
import 'package:git_hub_repositories/screens/search_screen/domain/entities/repo_model.dart';

abstract class FavoriteLocalSource {
  Future<List> getAllReposFromDb();

  Future<void> addRepoToDb(RepoModel repo);

  Future<void> deleteRepoFromDb(int id);
}

class LocalDataSourceSQlite implements FavoriteLocalSource {
  @override
  Future<void> addRepoToDb(RepoModel repo) async {
    final db = await RepoDatabase.instance.database;
    await db.insert('FavoriteRepos', repo.toMap());
  }

  @override
  Future<List<FavoriteModel>> getAllReposFromDb() async {
    final db = await RepoDatabase.instance.database;
    var result = await db.query('FavoriteRepos', columns: ['id', 'repoName']);
    return Future.value(
        result.map((list) => FavoriteModel.fromJson(list)).toList());
  }

  @override
  Future<int> deleteRepoFromDb(int id) async {
    final db = await RepoDatabase.instance.database;
    return await db.delete('FavoriteRepos', where: "id = ?", whereArgs: [id]);
  }
}
