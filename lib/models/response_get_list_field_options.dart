class ResponseGetFieldOptions {
  final List<FieldOptionGroup> fieldOptions;

  ResponseGetFieldOptions({required this.fieldOptions});

  factory ResponseGetFieldOptions.fromJson(List<dynamic> json) {
    return ResponseGetFieldOptions(
      fieldOptions: json
          .map((group) => FieldOptionGroup.fromJson(group as Map<String, dynamic>))
          .toList(),
    );
  }

  List<dynamic> toJson() {
    return fieldOptions.map((group) => group.toJson()).toList();
  }
}

class FieldOptionGroup {
  final String key;
  final String label;
  final List<FieldOption> options;

  FieldOptionGroup({
    required this.key,
    required this.label,
    required this.options,
  });

  factory FieldOptionGroup.fromJson(Map<String, dynamic> json) {
    return FieldOptionGroup(
      key: json['key'] as String,
      label: json['label'] as String,
      options: (json['options'] as List<dynamic>)
          .map((option) => FieldOption.fromJson(option as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
}

class FieldOption {
  final String id;
  final String name;
  final String? couleur;

  FieldOption({
    required this.id,
    required this.name,
    this.couleur,
  });

  factory FieldOption.fromJson(Map<String, dynamic> json) {
    return FieldOption(
      id: json['id'].toString(),
      name: json['name'].toString(),
      couleur: json['couleur']?['couleur']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'name': name,
    };
    if (couleur != null) {
      // data['couleur'] = {'couleur': couleur};
    }
    return data;
  }
}
