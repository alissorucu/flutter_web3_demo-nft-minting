class TokenModel {
  late int id;
  late String description;
  late String image;
  late String name;
  late bool hasSold;

  TokenModel(this.id, this.description, this.image, this.name);

  TokenModel.fromJson(Map<String, dynamic> json,this.hasSold) {
    id = json['id'];
    description = json['description'];
    image = json['image'];
    name = json['name'];
  }
}
