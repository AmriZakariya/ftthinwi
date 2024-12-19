class ResponseGetListEtats {
  List<Etat>? etats;

  ResponseGetListEtats({this.etats});

  ResponseGetListEtats.fromJson(Map<String, dynamic> json) {
    if (json['etat'] != null) {
      etats = <Etat>[];
      json['etat'].forEach((v) {
        etats!.add(Etat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (etats != null) {
      data['etat'] = etats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Etat {
  String? id;
  String? name;
  List<SousEtat>? sousEtats;

  Etat({this.id, this.name, this.sousEtats});

  Etat.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    if (json['sousEtat'] != null) {
      sousEtats = <SousEtat>[];
      json['sousEtat'].forEach((v) {
        sousEtats!.add(SousEtat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    if (sousEtats != null) {
      data['sousEtat'] = sousEtats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SousEtat {
  String? id;
  String? name;

  SousEtat({this.id, this.name});

  SousEtat.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}


