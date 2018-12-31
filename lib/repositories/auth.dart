import 'package:http/http.dart' as http;
import 'main_repository.dart';
import 'dart:convert';

class AuthSingleton {
  static final AuthSingleton _singleton = new AuthSingleton._internal();

  factory AuthSingleton() {
    return _singleton;
  }

  String _token;

  set token(String tok) => _singleton._token = tok;
  String get token => _singleton._token;

  Map<String, dynamic> authorize(Map<String, dynamic> json){
    if (_singleton.token == null) return json;
    json['token'] = _singleton.token;
    return json;
  }

  AuthSingleton._internal();
}

Future<bool> refreshToken() async{
  try{
    final jsonObj = {'token' : AuthSingleton().token};
    final response = await http.post(ENDPOINT_IDENTIFY, body: jsonObj);
    if (response.statusCode == 200) return true;
    if (response.statusCode == 401) return identify();
  }catch(e){ print(e); }
  return false;
}

Future<bool> identify() async{
  try{
    final response = await http.post(ENDPOINT_IDENTIFY);
    if (response.statusCode == 200){
      AuthSingleton().token  = json.decode(response.body)['token'];
      return true;
    }
  }catch(e){ print(e); }
  return false;
}