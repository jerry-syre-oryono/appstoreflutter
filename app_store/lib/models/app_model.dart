class AppModel {
  final int id;
  final String name;
  final String packageName;
  final String? description;
  final String? iconUrl;
  final int? latestVersionCode;
  final String? latestVersionName;

  AppModel({required this.id, required this.name, required this.packageName, this.description, this.iconUrl, this.latestVersionCode, this.latestVersionName});

  factory AppModel.fromJson(Map<String, dynamic> json) {
    final latest = json['latest_version'];
    return AppModel(
      id: json['id'],
      name: json['name'],
      packageName: json['package_name'],
      description: json['description'],
      iconUrl: json['icon_url'],
      latestVersionCode: latest != null ? latest['version_code'] : null,
      latestVersionName: latest != null ? latest['version_name'] : null,
    );
  }
}
