import 'package:http/http.dart' as http;
import 'main_repository.dart';
import 'dart:convert';

final int DELTA_VOLUME = 10;

Future<String> get_volume() async{
  try{
    final response = await http.get(ENDPOINT_VOLUME);
    if (response.statusCode == 200) return json.decode(response.body)['volume'];
  }catch(e){ print(e); }
  return null;
}

Future<bool> set_volume(bool up) async {
  final vol_req = await get_volume();
  if (vol_req == null) return false;

  final actual_volume = int.parse(vol_req);
  
  var future_volume;
  if (up) future_volume = (actual_volume + DELTA_VOLUME) > 100 ? 100 : (actual_volume + DELTA_VOLUME);
  else future_volume = (actual_volume - DELTA_VOLUME) > 0 ? (actual_volume - DELTA_VOLUME) : 0;

  final json_obj = json.encode({'volume' : future_volume});

  try{
    final response = await http.post(ENDPOINT_VOLUME, body: json_obj);
    if (response.statusCode == 200) return true;      
  }catch(e){ print(e); }
  return null;
}