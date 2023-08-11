import 'package:git_hub_repositories/screens/favorite_screen/domain/entities/favorite_model.dart';

abstract class FavoriteScreenState {}

class FavoriteInitial extends FavoriteScreenState {}

class Loaded extends FavoriteScreenState {
  final List<FavoriteModel> listFavoriteRepos;

  Loaded({required this.listFavoriteRepos});
}
