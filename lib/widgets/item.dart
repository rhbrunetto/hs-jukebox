import '../models/item.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../repositories/item.dart';


class ItemWidget extends StatefulWidget{
  final Item item;

  ItemWidget({@required this.item});

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
  
  final int interval_sec = 10;

  Item item_nowPlaying;
  List<Item> items;
  Timer events;

  @override
  void initState(){
    super.initState();
    generate_list();
    events = new Timer.periodic(Duration(seconds: interval_sec), (Timer t) => generate_list());
    widget.stream.listen((number) {
      print("Fetching after request from stream");
      generate_list();
    });
  }

  @override
  void dispose(){
    super.dispose();
    events.cancel();
  }

  void generate_list() async{
    final list = await fetch_items();
    if (list!=null){
      setState((){
        item_nowPlaying = list.length > 0 ? list.removeAt(0) : null;
        items = list;
      });
    }
  }

  Widget generic_title(String title, Widget content){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w500,
              fontSize: 20.0
              // shadows: [Shadow(color: Colors.purple, blurRadius: 10.0)]
            )
          )
        ),
        content,
      ]
    );
  }

  Widget get nowPlaying{
    return generic_title(
      'Now playing ♪',
      ItemWidget(
        item: item_nowPlaying
      )
    );
  }

  Widget get playlist{
    return generic_title(
      'Playlist',
      Flexible(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index){
            return ItemWidget(item: items[index]);
          }
        )
      )
    );
  }

  Widget get emptyList{
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:  MainAxisAlignment.center,
      children: <Widget>[
        Transform.scale(
          scale: 2.0,
          alignment: Alignment.bottomCenter,
          child: Icon(Icons.sentiment_dissatisfied, color: Colors.purple,)
        ),
        Text(
          'Parece que sua playlist está vazia!', style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.purple
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return item_nowPlaying == null ?
      emptyList
      :
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          nowPlaying,
          Divider(),
          Flexible( child: playlist )
        ],
      );
  } 
}