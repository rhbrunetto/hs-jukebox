import 'package:http/http.dart' as http;
import '../models/preview.dart';
import 'main_repository.dart';
import 'dart:convert';

Future<List<PreviewItem>> search_on_youtube(String query) async {
  final uri = new Uri.https(YOUTUBE_API, YOUTUBE_ENDPOINT,
    { "part": "snippet",
      "maxResults": "10",
      "q": query,
      "key": YOUTUBE_KEY,
    }
  );
  final s = uri.toString() + YOUTUBE_FILTER;
  print(s);
  try{
    final response = await http.get(s);
    if (response.statusCode == 200) {
      final obj = json.decode(response.body);
      final list = (obj['items'] as List)
          .map((data) => new PreviewItem.fromJson(data))
          .where((data) => data != null)
          .toList();
      return list;
    }
  }catch(e){ print(e); }
  return null;
}