import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:git_hub_repositories/screens/search_screen/domain/entities/history_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<String>> addToHistoryList(List<HistoryModel> lists);

  Future<List<HistoryModel>> getHistoryList();
}

const listKey = 'LIST_KEY';

class HistoryLocalDataSourcePref implements HistoryLocalDataSource {
  @override
  Future<List<String>> addToHistoryList(List<HistoryModel> lists) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> queryList =
        lists.map((list) => jsonEncode(list.toJson())).toList();
    prefs.setStringList(listKey, queryList);
    return Future.value(queryList);
  }

  @override
  Future<List<HistoryModel>> getHistoryList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final queryList = prefs.getStringList(listKey);

    if (queryList != null) {
      return Future.value(queryList
          .map((list) => HistoryModel.fromJson(jsonDecode(list)))
          .toList());
    } else {
      return Future.value([]);
    }
  }
}
