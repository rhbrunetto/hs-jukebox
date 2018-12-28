
class PreviewItem{
  final String videoId, title, channelTitle, imageUrl;

  PreviewItem({this.videoId, this.title, this.channelTitle, this.imageUrl});

  factory PreviewItem.fromJson(Map<String, dynamic> json){
    return new PreviewItem(
      videoId: json['id']['videoId'],
      title: json['snippet']['title'],
      channelTitle: json['snippet']['channelTitle'],
      imageUrl: json['snippet']['thumnails']['default']['url']
    );
  }

}

// https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&order=viewCount&q=skateboarding+dog&type=video&videoDefinition=high&fields=items(id%2FvideoId%2Csnippet(channelTitle%2Cthumbnails%2Fdefault%2Furl%2Ctitle))&key={YOUR_API_KEY}
//  AIzaSyBNw1HoJNlAIzgy67_XKrNaXusJkrQE33U