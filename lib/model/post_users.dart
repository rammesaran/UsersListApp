class PostUsers {
  String id;
  String createdAt;

  PostUsers({this.id, this.createdAt});

  PostUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    return data;
  }
}