class UserResponse {
  String? id;
  int? lastRequestTime;
  String? username;
  String? email;
  bool? active;
  bool? verifiedEmail;
  Null? deviceIDs;
  Null? currentDeviceID;
  String? type;
  Null? dob;
  String? firstName;
  String? lastName;
  bool? enabled;
  bool? accountNonExpired;
  bool? accountNonLocked;
  bool? credentialsNonExpired;
  Null? authorities;

  UserResponse(
      {this.id,
        this.lastRequestTime,
        this.username,
        this.email,
        this.active,
        this.verifiedEmail,
        this.deviceIDs,
        this.currentDeviceID,
        this.type,
        this.dob,
        this.firstName,
        this.lastName,
        this.enabled,
        this.accountNonExpired,
        this.accountNonLocked,
        this.credentialsNonExpired,
        this.authorities});

  UserResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    lastRequestTime = json['lastRequestTime'];
    username = json['username'];
    email = json['email'];
    active = json['active'];
    verifiedEmail = json['verifiedEmail'];
    deviceIDs = json['deviceIDs'];
    currentDeviceID = json['currentDeviceID'];
    type = json['type'];
    dob = json['dob'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    enabled = json['enabled'];
    accountNonExpired = json['accountNonExpired'];
    accountNonLocked = json['accountNonLocked'];
    credentialsNonExpired = json['credentialsNonExpired'];
    authorities = json['authorities'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lastRequestTime'] = this.lastRequestTime;
    data['username'] = this.username;
    data['email'] = this.email;
    data['active'] = this.active;
    data['verifiedEmail'] = this.verifiedEmail;
    data['deviceIDs'] = this.deviceIDs;
    data['currentDeviceID'] = this.currentDeviceID;
    data['type'] = this.type;
    data['dob'] = this.dob;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['enabled'] = this.enabled;
    data['accountNonExpired'] = this.accountNonExpired;
    data['accountNonLocked'] = this.accountNonLocked;
    data['credentialsNonExpired'] = this.credentialsNonExpired;
    data['authorities'] = this.authorities;
    return data;
  }
}