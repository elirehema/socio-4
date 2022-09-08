
class GoogleAuthentication{

  String id;
  String userName;
  String email;
  String score;
  String status;
  String photoURL;
  String language;
  String languageCode;

  GoogleAuthentication(this.id, this.userName,this.email, this.score, this.status,  this.photoURL, this.language, this.languageCode);

  factory GoogleAuthentication.fromJson (Map<String, dynamic> json){
    return GoogleAuthentication(
        json["id_user"],
        json["name_user"],
        json["email_user"],
        json["score"],
        json["status_user"],
        json["photo_user"],
        json["language"],
        json["language_code"]);
  }

}