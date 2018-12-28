
RegExp exp = new RegExp(r".*www\.youtube\.com/watch\?v=(.*)");

class Item{
  final String url, title;
  final String duration;

  String imageUrl;

  Item(this.url, this.title, this.duration){
    try{
      if (exp.hasMatch(url))
        imageUrl = 'https://img.youtube.com/vi/${exp.firstMatch(url).group(1)}/default.jpg';
    }catch(Exception){
      imageUrl = null;
    }
    // final d = Duration(seconds: duration);
    // printDuration(d, abbreviated: true);
    // print(formatDate(new DateTime(duration), [HH, '-', nn, '-', ss]));
  }

  factory Item.fromJson(Map<String, dynamic> json){
    return new Item(
      json['url'],
      json['title'],
      json['duration']
    );
  }
}