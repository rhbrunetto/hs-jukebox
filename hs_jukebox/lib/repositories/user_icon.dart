import 'package:http/http.dart' as http;
import 'main_repository.dart';

Future<int> fetch_users() async{
  try{
    final response = await http.get(ENDPOINT_USERS);
    if (response.statusCode == 200) {
      final value = int.parse(response.body);
      print('[Fetched users online from API]');
      return value;
    }
    return null;
  }catch(e){ print(e); }
  return null;
}