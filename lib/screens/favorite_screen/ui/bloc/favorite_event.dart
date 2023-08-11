abstract class FavoriteEvent {}

class GetFavoriteRepos extends FavoriteEvent {}

class RemoveRepo extends FavoriteEvent {
  final int repoId;

  RemoveRepo({required this.repoId});
}
