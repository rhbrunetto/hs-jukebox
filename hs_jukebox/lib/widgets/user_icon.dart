import 'dart:async';
import 'package:flutter/material.dart';
import '../repositories/user_icon.dart';

class UsersOnlineWidget extends StatefulWidget{

  @override
  _UsersOnlineWidgetState createState() => _UsersOnlineWidgetState();
} 


class _UsersOnlineWidgetState extends State<UsersOnlineWidget>{

  final int interval_sec = 10;

  int count;
  Timer events;

  @override
  void initState(){
    super.initState();
    refresh_users();
    events = new Timer.periodic(Duration(seconds: interval_sec), (Timer t) => refresh_users());
  }

  void refresh_users() async{
    final value = await fetch_users();
    if (value!=null) setState(() => count = value);
  }

  @override
  void dispose(){
    super.dispose();
    events.cancel();
  }

  Widget get user_indicator{
    return Positioned(
      bottom: -1.0,
      right: -1.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[          
          Icon(
            Icons.brightness_1,
            color: Colors.purple,
            size: 12.0,
            // color: const Color(0xFF2845E7),
          ),
          Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white, 
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ) 
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
      // alignment: Alignment.center,
      // children: <Widget>[
        // Icon(Icons.people),
    return IconButton(
      icon: Stack(
        children: <Widget>[
          Icon(Icons.supervisor_account),
          user_indicator
        ],
      ),
      onPressed: (){},
    );
  }
}
