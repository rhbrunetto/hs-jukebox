import 'package:flutter/material.dart';
import 'dart:async';
import 'widgets/item.dart';
import 'widgets/preview.dart';
import 'widgets/diamond_shape.dart';

void main() => runApp(MyApp());

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


  Future _search_youtube() async{
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PreviewItemList())
    );
    _controller.add(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _search_youtube            
          )
        ],
      ),
      body: Center(
        child: ItemListWidget(stream: _controller.stream),
      ),
      floatingActionButton: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Transform.scale(
            scale: 0.7,
            child: FloatingActionButton(
              shape: DiamondBorder(up: true),
              onPressed: () => print('oi'),
              child: Icon(Icons.add),
            )
          ),
          Transform.scale(
            scale: 0.7,
            child: FloatingActionButton(
              shape: DiamondBorder(up: false),
              onPressed: () => print('oi'),
              child: Icon(Icons.remove),
            )
          ),
          FloatingActionButton(
            onPressed: () => print('oi'),
            child: Icon(Icons.queue_music),
          )
        ]
      )
    );
  }
}
