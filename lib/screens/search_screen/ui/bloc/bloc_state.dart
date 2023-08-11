import 'package:git_hub_repositories/screens/search_screen/domain/entities/history_model.dart';
import 'package:git_hub_repositories/screens/search_screen/domain/entities/repo_model.dart';

abstract class SearchScreenState {}

class InitialState extends SearchScreenState {}

class Loading extends SearchScreenState {}

class Loaded extends SearchScreenState {
  final List<RepoModel> listRepo;

  Loaded({required this.listRepo});
}

class Pagination extends SearchScreenState {
  final List<RepoModel> currentListRepos;

  Pagination(this.currentListRepos);
}

class FavoriteAdded extends SearchScreenState {
  int index;

  FavoriteAdded({required this.index});
}

class ErrorState extends SearchScreenState {
  String message;

  ErrorState(this.message);
}

class HistoryLoaded extends SearchScreenState {
  final List<HistoryModel> historyList;

  HistoryLoaded({required this.historyList});
}
