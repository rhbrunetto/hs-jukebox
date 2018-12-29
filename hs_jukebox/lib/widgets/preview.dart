import '../models/preview.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


final String KEY = "AIzaSyBNw1HoJNlAIzgy67_XKrNaXusJkrQE33U";

class PreviewItemWidget extends StatefulWidget{
  final PreviewItem item;

  PreviewItemWidget({this.item});

  @override
  _PreviewItemWidgetState createState() => _PreviewItemWidgetState();
}

class _PreviewItemWidgetState extends State<PreviewItemWidget>{
  final double _total_height = 75.0;
  final double _pic_w = 80.0;
  final double _pic_h = 60.0;
  final double _radius  = 10.0;

  bool uploading = false;

  void add_video() async{
    setState(() {
          uploading = true;
        });
    try{
      print(widget.item.videoUrl);
      final response = await http.post('http://192.168.0.10:3000/api/items/enqueue', body: widget.item.videoUrl);
      if (response.statusCode == 204) {
        Navigator.of(context).pop();
        return;
      }
    }catch(Exception){}
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Erro ao adicionar à playlist :(')
      )
    );
    setState(() {
      uploading = false;
    });
  }

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
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      widget.item.title,
                      style: Theme.of(context).textTheme.subtitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.item.channelTitle,
                      style: Theme.of(context).textTheme.caption,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: add_video,
                      icon: Icon(Icons.add),
                    )
                  ),
                )
              )
            ]
          )
      ),
    );
  }

  Widget get progressbar{
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build (BuildContext context){
    return 
    uploading ? progressbar
    : SizedBox(
      width: double.infinity,
      height: _total_height,
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
    );
  }
}



class PreviewItemList extends StatefulWidget{
  @override
  _PreviewItemListState createState() => _PreviewItemListState();
}

class _PreviewItemListState extends State<PreviewItemList>{
  final TextEditingController query_controller = new TextEditingController();
  List<PreviewItem> items;
  String query;
  
  Icon _searchIcon = new Icon(Icons.search); 
  Widget _appBarTitle = new Text('Search on Youtube');


  _PreviewItemListState(){
    query_controller.addListener(() {
      if (query_controller.text.isEmpty) {
        setState(() {
          query = null;
          items = null;
        });
      } else if (query == null || query_controller.text == null || (query.length - query_controller.text.length).abs() > 2){
        setState(() {
          query = query_controller.text;
          search();
        });
      }
    });
  }

  void search() async{
    if (query == null) return;
    final uri = new Uri.https('www.googleapis.com', '/youtube/v3/search',
      { "part":"snippet",
        "maxResults":"5",
        "q":query,
        "key":KEY,
      }
    );
    final s = uri.toString() + "&fields=items(id%2FvideoId%2Csnippet(channelTitle%2Cthumbnails%2Fdefault%2Furl%2Ctitle))";
    print(s);
    final response = await http.get(s);
    if (response.statusCode == 200) {
      print(response.body);
      final obj = json.decode(response.body);
      final list = (obj['items'] as List)
          .map((data) => new PreviewItem.fromJson(data))
          .toList();
      setState(() => items = list);
    }
  }

  Widget get list{
    return items == null ?
    Container()
    :
    ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index){
        return PreviewItemWidget(item: items[index]);
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: query_controller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search on Youtube'
          ),
        )
      ),
      body: list
    );
  } 
}