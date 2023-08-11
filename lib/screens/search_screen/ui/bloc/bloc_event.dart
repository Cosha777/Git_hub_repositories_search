abstract class SearchScreenEvent {}

class GetReposByName extends SearchScreenEvent {
  final String text;
  final int page;

  GetReposByName({required this.text, required this.page});
}

class AddToFavorite extends SearchScreenEvent {
  final int index;
  final int repoId;

  AddToFavorite({required this.repoId, required this.index});
}

class OnPagination extends SearchScreenEvent {
  final String text;
  final int page;

  OnPagination({required this.text, required this.page});
}

class GetHistoryList extends SearchScreenEvent {}
