class ProfileModel {
  String name;
  String email;
  String? photoUrl;

  ProfileModel({
    required this.name,
    required this.email,
    this.photoUrl,
  });
}
