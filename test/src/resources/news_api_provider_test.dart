import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('fetchTopIds returns a list of Ids', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });
    final ids = await newsApi.fetchTopIds();

    expect(ids, [1, 2, 3, 4]);
  });

  test('fetchItem returns a ItemModel', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {"id": 123,
        "type": "",
        "by": "",
        "time": 1,
        "text": "",
        "parent": 1,
        "url": "",
        "score": 1,
        "title": "",
        "descendants": 1,
        "dead": false,
        "deleted": false,
        "kids": [1,2]
      };
      return Response(json.encode(jsonMap), 200);
    });
    final item = await newsApi.fetchItem(123);
    expect(item.id, 123);
  });
}
