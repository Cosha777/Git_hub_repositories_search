import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:git_hub_repositories/screens/favorite_screen/data/repositories/local_data_source.dart';
import 'package:git_hub_repositories/screens/search_screen/data/repositories/history_local_data_sourse.dart';
import 'package:git_hub_repositories/screens/search_screen/data/repositories/remote_data_source.dart';
import 'package:git_hub_repositories/screens/search_screen/domain/entities/history_model.dart';
import 'package:git_hub_repositories/screens/search_screen/domain/entities/repo_model.dart';

import 'bloc_event.dart';
import 'bloc_state.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  final RemoteDataService _remoteDataService;
  final FavoriteLocalSource _favoriteLocalSource;
  final HistoryLocalDataSource _historyLocalDataSource;
  List<RepoModel> currentListRepos = [];
  List<HistoryModel> _historyList = [];

  SearchScreenBloc(this._remoteDataService, this._favoriteLocalSource,
      this._historyLocalDataSource)
      : super(InitialState()) {
    on<GetReposByName>((event, emit) async {
      emit(Loading());
      currentListRepos = [];
      _historyList.insert(0, HistoryModel(query: event.text));
      await _historyLocalDataSource.addToHistoryList(_historyList);
      try {
        final result =
            await _remoteDataService.getRepoByName(event.text, event.page);
        currentListRepos.addAll(result);
        emit(Loaded(listRepo: currentListRepos));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<AddToFavorite>((event, emit) async {
      if (currentListRepos[event.index].isFavorite == false) {
        currentListRepos[event.index].isFavorite =
            !currentListRepos[event.index].isFavorite;
        _favoriteLocalSource.addRepoToDb(currentListRepos[event.index]);
      } else {
        currentListRepos[event.index].isFavorite =
            !currentListRepos[event.index].isFavorite;
        _favoriteLocalSource.deleteRepoFromDb(event.repoId);
      }
      emit(Loaded(listRepo: currentListRepos));
    });

    on<OnPagination>((event, emit) async {
      emit(Loading());
      try {
        final result =
            await _remoteDataService.getRepoByName(event.text, event.page);
        currentListRepos.addAll(result);
        emit(Loaded(listRepo: currentListRepos));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    on<GetHistoryList>((event, emit) async {
      var list = await _historyLocalDataSource.getHistoryList();
      _historyList = list;
      emit(HistoryLoaded(historyList: list));
    });
  }
}
