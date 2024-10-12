import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_headlines_model.dart';

///yh class sirf api sy data fetch kry gi
class NewsRepository {
  ///future function es ly create kya k hmy nhi pta k data kitni daar main fetch hoga
  Future<NewsHeadlinesModel> fetchNewsHeadlinesApi(String channelName) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=3b14097ccab246e2b04996cb7ad59054';

    ///http package api sy any waly data ko backend pr controll krta ha
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      ///kdebug app release main nhi jata...yh sirf console main print hota h..print es ly likha taky hm check kr ly k api sy data fetch ho rha ha ya nhi
      if (kDebugMode) {
        print(response.body);
      }
      final body = jsonDecode(response.body);
      //fetchheadlines function body return krta ha
      return NewsHeadlinesModel.fromJson(body);
    }
    throw Exception('error');
  }

  Future<CategoriesNewsModel> fetchNewsCategoires(String category) async {
    String newsUrl =
        'https://newsapi.org/v2/everything?q=$category&apiKey=8a5ec37e26f845dcb4c2b78463734448';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return CategoriesNewsModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }
}
