import '../models/item.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ItemWidget extends StatefulWidget{
  final Item item;

  ItemWidget({this.item});

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget>{
  final double _total_height = 75.0;
  final double _pic_w = 80.0;
  final double _pic_h = 60.0;
  final double _radius  = 10.0;

  Widget get thumbImage{
    var thumbnail = Container(
        width:  _pic_w,
        height: _pic_h,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(_radius)),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(widget.item.imageUrl ?? '')
          )
        ),
    );
    
    var placeholder = Container(
      width: _pic_w,
      height: _pic_h,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
        color: Colors.black
      ),
      alignment: Alignment.center,
      child: Text(
        '♫',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      )
    );
  
    return AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: thumbnail,
      crossFadeState: widget.item.imageUrl == null
        ? CrossFadeState.showFirst
        : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 500)
    );
  }

  Widget get card{
    return Card(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 50.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                widget.item.title,
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    widget.item.duration ?? '--:--',
                    style: Theme.of(context).textTheme.subtitle,
                  )
                ),
              )
            ],
          )
      ),
    );
  }

  @override
  Widget build (BuildContext context){
    return SizedBox(
      width: double.infinity,
      height: _total_height,
      child: InkWell(
        onTap: () => print('You clicked ${widget.item.title}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                left: _pic_w/2,
                child: card,
              ),
              Positioned(top: (_total_height - _pic_h)/2, child: thumbImage),
            ],
          ),
        )
      )
    );
  }
}



class ItemListWidget extends StatefulWidget{
  Stream<int> stream;
  // Stream is required to keep notifications
  ItemListWidget({@required this.stream});

  @override
  _ItemListWidgetState createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget>{
  List<Item> items;
  Timer events;
  final int interval_sec = 10;

  void initState(){
    super.initState();
    fetch_items();
    events = new Timer.periodic(Duration(seconds: interval_sec), (Timer t) => fetch_items());
    widget.stream.listen((number) {
      print("Fetching after request from stream");
      fetch_items();
    });
  }

  void dispose(){
    super.dispose();
    events.cancel();
  }

  void fetch_items() async{
    try{
      final response = await http.get("http://192.168.0.10:3000/api/items");
      if (response.statusCode == 200) {
        final list = (json.decode(response.body) as List)
            .map((data) => new Item.fromJson(data))
            .toList();
        print('[Fetched items from API]');
        setState(() => items = list);
      }
    }catch(Exception){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Erro ao buscar músicas :(')
        )
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return items == null ?
      CircularProgressIndicator()
      :
      ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          return ItemWidget(item: items[index]);
        }
      );
  } 
}