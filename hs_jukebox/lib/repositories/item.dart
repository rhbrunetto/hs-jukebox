import 'package:http/http.dart' as http;
import '../models/item.dart';
import 'main_repository.dart';
import 'dart:convert';

Future<bool> enqueue(String url) async{
  try{
    final jsonObj = json.encode({'url': url});
    final response = await http.post(ENDPOINT_ENQUEUE, body: jsonObj);
    if (response.statusCode == 200) return true;
    return false;
  }catch(e){
    print(e);
  }
  return false;
}

Future<List<Item>> fetch_items() async{
  try{
    final response = await http.get(ENDPOINT_ITEMS);
    if (response.statusCode == 200) {
      final list = (json.decode(response.body) as List)
          .map((data) => new Item.fromJson(data))
          .toList();
      print('[Fetched items from API]');
      return list;
    }
    return null;
  }catch(e){ print(e); }
  return null;
}