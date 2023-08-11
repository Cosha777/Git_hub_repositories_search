import 'package:flutter/material.dart';
import 'package:git_hub_repositories/screens/search_screen/domain/entities/repo_model.dart';
import 'package:git_hub_repositories/screens/search_screen/ui/widgets/circular_progress_indicator.dart';
import 'package:git_hub_repositories/screens/search_screen/ui/widgets/search_text_field.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_hub_repositories/screens/favorite_screen/ui/favorit_screen.dart';
import 'package:git_hub_repositories/screens/search_screen/ui/bloc/bloc_event.dart';

import 'bloc/bloc_bloc.dart';
import 'bloc/bloc_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final RefreshController refreshController = RefreshController();
  int _currentPage = 1;
  bool _isPagination = false;
  List<RepoModel> _currentResults = [];

  @override
  Widget build(BuildContext context) {
    final SearchScreenBloc bloc = context.read<SearchScreenBloc>();
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title:
              const Text('SuperZombi', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoriteScreen(),
                  )),
              color: Colors.blue,
              icon: const Icon(Icons.star),
            ),
          ],
          backgroundColor: Colors.grey[200],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SearchTextField(controller: _controller),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Results'),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white30),
                  child: BlocBuilder<SearchScreenBloc, SearchScreenState>(
                    builder: (context, state) {
                      if (state is InitialState) {
                        bloc.add(GetHistoryList());
                        return const CircularIndicator();
                      }

                      if (state is HistoryLoaded) {
                        return _historyListView(state);
                      }

                      if (state is Loading) {
                        if (!_isPagination) {
                          return const CircularIndicator();
                        } else {
                          return _reposListView(bloc, _currentResults);
                        }
                      }

                      if (state is Loaded) {
                        _currentResults = bloc.currentListRepos;
                        refreshController.loadComplete();
                        _isPagination = false;
                        return _reposListView(bloc, _currentResults);
                      }

                      if (state is ErrorState) {
                        return Center(
                            child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                        ));
                      } else {
                        return const Center(child: Text('Something wrong '));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _currentResults = [];
            if (_controller.text.isNotEmpty) {
              bloc.add(
                  GetReposByName(text: _controller.text, page: _currentPage));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Enter repository name..."),
                duration: Duration(seconds: 1),
              ));
            }
          },
          child: const Icon(Icons.find_in_page),
        ),
      ),
    );
  }

  Widget _historyListView(HistoryLoaded state) {
    return ListView.builder(
      itemCount: state.historyList.length,
      itemBuilder: (context, position) {
        return Card(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              state.historyList[position].query,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  Widget _reposListView(SearchScreenBloc bloc, List<RepoModel> currentResults) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      enablePullDown: false,
      onLoading: () {
        _isPagination = true;
        _currentPage++;
        bloc.add(OnPagination(text: _controller.text, page: _currentPage));
      },
      child: ListView.builder(
        itemCount: currentResults.length,
        itemBuilder: (context, position) {
          return Card(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      '${position + 1} ${currentResults[position].repoName}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  IconButton(
                    color: bloc.currentListRepos[position].isFavorite == false
                        ? Colors.grey
                        : Colors.blue,
                    onPressed: () {
                      bloc.add(AddToFavorite(
                          index: position,
                          repoId: currentResults[position].id));
                    },
                    icon: const Icon(Icons.star),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
