
// RegExp exp = new RegExp(r".*www\.youtube\.com/watch\?v=(.*)");

class Item{
  final String url, title;
  final String duration;

  String imageUrl;

  Item(this.url, this.title, this.duration){
    try{
      // if (exp.hasMatch(url))
        // imageUrl = 'https://img.youtube.com/vi/${exp.firstMatch(url).group(1)}/default.jpg';
      imageUrl = 'https://img.youtube.com/vi/${url}/default.jpg';
    }catch(Exception){
      imageUrl = null;
    }
  }

  factory Item.fromJson(Map<String, dynamic> json){
    return new Item(
      json['url'],
      json['title'],
      json['duration']
    );
  }
}