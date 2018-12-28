
RegExp exp = new RegExp(r".*www\.youtube\.com/watch\?v=(\w+)");

class Item{
  final String url, title;
  final int duration;

  String imageUrl;
  String formatted_duration;

  Item(this.url, this.title, this.duration){
    if (exp.hasMatch(url))
      imageUrl = 'https://img.youtube.com/vi/${exp.firstMatch(url).group(1)}/default.jpg';
    // final d = Duration(seconds: duration);
    // printDuration(d, abbreviated: true);
    formatted_duration = duration.toString();
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