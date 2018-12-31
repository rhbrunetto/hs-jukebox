import 'package:flutter/material.dart';
import 'dart:async';

import 'repositories/item.dart';
import 'repositories/volume.dart';
import 'repositories/auth.dart';

import 'widgets/item.dart';
import 'widgets/preview.dart';
import 'widgets/dialog_input.dart';
import 'widgets/user_icon.dart';

void main() => runApp(MyApp());

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HSJuke',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'HS Jukebox'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StreamController<int> _controller = StreamController<int>();
  Timer events;
  final int interval_sec_refresh_token = 180;

  @override
  void initState(){
    super.initState();
    first_login();
    events = new Timer.periodic(Duration(seconds: interval_sec_refresh_token), (Timer t) => refreshToken());
  }

  void first_login() async{
    final success = await identify();
    if(!success) show_snack('Falha na autenticação!');
  }

  @override
  void dispose(){
    super.dispose();
    events.cancel();
  }

  void refresh_playlist(){
    _controller.add(0);
  }

  Future _search_youtube() async{
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PreviewItemList())
    );
    refresh_playlist();
  }

  Future _submit_url(String url) async{
    bool success = await enqueue(url);
    if (success) refresh_playlist();
    else show_snack('Erro ao adicionar à playlist :(');
  }

  Future _put_url() async {
    String newurl = await showDialog(
      context: context,
      child: InputDialog()
    );
    if (newurl != null){
      print(newurl);
      _submit_url(newurl);
    }
  }

  void change_volume(bool up) async{
    print("OLAAAAAAAAAAR");
    bool success = await set_volume(up);
    if(!success) show_snack('Erro ao alterar o volume :(');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          UsersOnlineWidget(),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _search_youtube            
          )
        ],
      ),
      body: Center(
        child: ItemListWidget(stream: _controller.stream),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _put_url,
        child: Icon(Icons.queue_music),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.purple,
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[          
            IconButton(icon: Icon(Icons.volume_down), onPressed: () => change_volume(false), color: Colors.white),
            IconButton(icon: Icon(Icons.volume_up), onPressed: () => change_volume(true), color: Colors.white),
          ],
        ),
      ),
    );
  }
}

void show_snack(String text){
  _scaffoldKey.currentState.showSnackBar(
    SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(text)
    )
  );
}