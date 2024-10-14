import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

///yh kyo bnaya???
/// It acts as a bridge between the UI (view) and the data repository (model)
class NewsViewModel {
  static final _repo = NewsRepository();
  static Future<NewsHeadlinesModel> fetchNewsHeadlinesApi(
      String channelName) async {
    final response = await _repo.fetchNewsHeadlinesApi(channelName);
    return response;
  }

  static Future<CategoriesNewsModel> fetchNewsCategoires(
      String category) async {
    final response = await _repo.fetchNewsCategoires(category);
    return response;
  }
}
