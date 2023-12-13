class GeoPunch {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String? updatedAt;

  GeoPunch({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.updatedAt,
  });

  factory GeoPunch.fromJson(Map<String, dynamic> json) {
    return GeoPunch(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['long']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  static List<GeoPunch> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => GeoPunch.fromJson(json)).toList();
  }
}
