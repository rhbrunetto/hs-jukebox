
class PreviewItem{
  final String videoId, title, channelTitle, imageUrl;
  String videoUrl;

  PreviewItem({this.videoId, this.title, this.channelTitle, this.imageUrl}){
    videoUrl = "https://www.youtube.com/watch?v=${videoId}";
  }

  factory PreviewItem.fromJson(Map<String, dynamic> json){
    if (!json.containsKey('id') || !json.containsKey('snippet')) return null;
    return new PreviewItem(
      videoId: json['id']['videoId'],
      title: json['snippet']['title'],
      channelTitle: json['snippet']['channelTitle'],
      imageUrl: json['snippet']['thumbnails']['default']['url']
    );
  }

}
