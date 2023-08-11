import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_hub_repositories/data_bases/favorite_repos_database.dart';
import 'package:git_hub_repositories/screens/favorite_screen/data/repositories/local_data_source.dart';
import 'package:git_hub_repositories/screens/search_screen/data/repositories/history_local_data_sourse.dart';
import 'package:git_hub_repositories/screens/search_screen/data/repositories/remote_data_source.dart';
import 'package:git_hub_repositories/screens/search_screen/ui/bloc/bloc_bloc.dart';
import 'package:git_hub_repositories/screens/search_screen/ui/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<SearchScreenBloc>(
        create: (BuildContext context) =>
            SearchScreenBloc(RemoteDataSourceHTTP(),  LocalDataSourceSQlite(), HistoryLocalDataSourcePref()),
        child: const SearchScreen(),
      ),
    );
  }
}
