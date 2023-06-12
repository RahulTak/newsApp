import 'package:intl/intl.dart';
import 'package:news_app/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';

class News {
  List<ArticleModel> news = [];

  Future getNews({String? page}) async {
    String kNewsEndpoint =
        'https://api.thenewsapi.com/v1/news/all?api_token=JM5QmjrdsMN3j1vDqp64antyzhgQX6MWfzgsmxba&language=en&limit=3&page=$page';

    http.Client client = http.Client();
    http.Response response = await client.get(Uri.parse(kNewsEndpoint));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData['data'] != null) {
        jsonData['data'].forEach((element) {
          if (element['image_url'] != "" &&
              element['description'] != "" &&
              element['url'] != null) {
            DateTime dt = DateTime.parse(element['published_at']);
            String formattedTime = DateFormat.jm().format(dt);
            String formattedDate = DateFormat.yMMMMd('en_US').format(dt);
            ArticleModel articleModel = ArticleModel(
              publishedDate: formattedDate,
              publishedTime: formattedTime,
              image: element['image_url'].toString(),
              content: element['description'].toString(),
              fullArticle: element['url'].toString(),
              title: element['title'].toString(),
            );
            news.add(articleModel);
          }
        });
      } else {
        print('ERROR');
      }
    }
  }
}
