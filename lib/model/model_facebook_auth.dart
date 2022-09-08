class FacebookAuthentication{
  int height;
  String url;
  int width;
  bool is_silhouette;
  FacebookAuthentication(this.height, this.url, this.width, this.is_silhouette);
  factory FacebookAuthentication.fromJson(Map<String, dynamic> json){
    return FacebookAuthentication(json['height'], json['url'].toString().trim(), json['width'], json['is_silhouette']);
  }
}