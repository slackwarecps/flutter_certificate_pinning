class HealthStatus {
  final String status;
  final String? name;
  final String? description;
  final String? version;

  HealthStatus({
    required this.status,
    this.name,
    this.description,
    this.version,
  });

  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    return HealthStatus(
      status: json['status'] ?? 'UNKNOWN',
      name: json['name'],
      description: json['description'],
      version: json['version'],
    );
  }
}
