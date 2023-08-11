import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:git_hub_repositories/screens/favorite_screen/data/repositories/local_data_source.dart';
import 'package:git_hub_repositories/screens/favorite_screen/ui/bloc/favorite_bloc.dart';
import 'package:git_hub_repositories/screens/favorite_screen/ui/bloc/favorite_state.dart';

import 'bloc/favorite_event.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteScreenBloc>(
      create: (BuildContext context) =>
          FavoriteScreenBloc(LocalDataSourceSQlite()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'SuperZombi',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[200],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Favorite repositories'),
                ),
                Expanded(
                  child: Container(
                    height: 700,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white30),
                    child: BlocBuilder<FavoriteScreenBloc, FavoriteScreenState>(
                      builder: (context, state) {
                        if (state is FavoriteInitial) {
                          context
                              .read<FavoriteScreenBloc>()
                              .add(GetFavoriteRepos());
                        }

                        if (state is Loaded) {
                          return _buildListView(state);
                        } else {
                          return const Center(child: Text('No Favorites'));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildListView(Loaded state) {
    return ListView.builder(
      itemCount: state.listFavoriteRepos.length,
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
                    ' ${state.listFavoriteRepos[position].title}     id: ${state.listFavoriteRepos[position].id}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                IconButton(
                  color: Colors.blue,
                  onPressed: () {
                    context.read<FavoriteScreenBloc>().add(RemoveRepo(
                        repoId: state.listFavoriteRepos[position].id));
                  },
                  icon: const Icon(Icons.star),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
