class GoogleUser {
  final String id;
  final String? displayName;
  final String email;

  GoogleUser({
    required this.id,
    this.displayName,
    required this.email,
  });

  GoogleUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        displayName = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'email': email,
      };
}
