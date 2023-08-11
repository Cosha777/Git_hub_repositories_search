import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:git_hub_repositories/screens/favorite_screen/data/repositories/local_data_source.dart';
import 'package:git_hub_repositories/screens/favorite_screen/ui/bloc/favorite_event.dart';
import 'package:git_hub_repositories/screens/favorite_screen/ui/bloc/favorite_state.dart';

class FavoriteScreenBloc extends Bloc<FavoriteEvent, FavoriteScreenState> {
  final LocalDataSourceSQlite _pref;

  FavoriteScreenBloc(this._pref) : super(FavoriteInitial()) {
    on<GetFavoriteRepos>((event, emit) async {
      final name = await _pref.getAllReposFromDb();

      emit(Loaded(listFavoriteRepos: name));
    });

    on<RemoveRepo>((event, emit) async {
      await _pref.deleteRepoFromDb(event.repoId);
      final name = await _pref.getAllReposFromDb();

      emit(Loaded(listFavoriteRepos: name));
    });
  }
}
