class ResponseGetDemandesList {
  List<Demande>? demandes;

  ResponseGetDemandesList({this.demandes});

  ResponseGetDemandesList.fromJson(Map<String, dynamic> json) {
    if (json['demandes'] != null) {
      demandes = <Demande>[];
      json['demandes'].forEach((v) {
        demandes!.add(new Demande.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.demandes != null) {
      data['demandes'] = this.demandes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Demand {
  List<Demande> demandes;

  Demand({required this.demandes});

  factory Demand.fromJson(Map<String, dynamic> json) {
    return Demand(
      demandes:
          (json['demandes'] as List).map((i) => Demande.fromJson(i)).toList(),
    );
  }
}

class Demande {
  String? id;
  String? userId;
  String? numero;
  String? parent;
  String? numeroLigne;
  String? plaqueId;
  String? groupeAffectation;
  String? idCommande;
  String? consommateur;
  String? telMobile;
  String? createdSource;
  String? adresseComplement1;
  String? ftthSn;
  String? snRouteur;
  String? adresseMac;
  String? refRouteur;
  String? description;
  String? numIdentification;
  String? fournisseur;
  String? dateResolution;
  String? etatId;
  String? subStatutId;
  String? dateRdv;
  String? longitude;
  String? latitude;
  String? offreId;
  String? articleId;
  String? cableFibre;
  String? boiteTypeId;
  String? numFat;
  String? numSplitter;
  String? numSlimbox;
  String? positionId;
  String? speedUpload;
  String? speedDownload;
  String? signatureClient;
  String? pRouteurAllume;
  String? pTestSignalViaPm;
  String? pPriseAvant;
  String? pPriseApres;
  String? pPassageCableAvant;
  String? pPassageCableApres;
  String? pCassetteRecto;
  String? pCassetteVerso;
  String? pSpeedTest;
  String? pDosRouteurCin;
  String? pNapFatBbOuvert;
  String? pNapFatBbFerme;
  String? pSlimboxOuvert;
  String? pSlimboxFerme;
  String? etatProvisioningId;
  String? commentaire;
  String? archiveId;
  String? created;
  String? etatName;
  String? type;
  String? plaqueName;
  List<Commentaire>? commentaires;

  var etape; // Keeping it dynamic since no structure provided

  Demande({
    this.id,
    this.userId,
    this.numero,
    this.parent,
    this.numeroLigne,
    this.plaqueId,
    this.groupeAffectation,
    this.idCommande,
    this.consommateur,
    this.telMobile,
    this.createdSource,
    this.adresseComplement1,
    this.ftthSn,
    this.snRouteur,
    this.adresseMac,
    this.refRouteur,
    this.description,
    this.numIdentification,
    this.fournisseur,
    this.dateResolution,
    this.etatId,
    this.subStatutId,
    this.dateRdv,
    this.longitude,
    this.latitude,
    this.offreId,
    this.articleId,
    this.cableFibre,
    this.boiteTypeId,
    this.numFat,
    this.numSplitter,
    this.numSlimbox,
    this.positionId,
    this.speedUpload,
    this.speedDownload,
    this.signatureClient,
    this.pRouteurAllume,
    this.pTestSignalViaPm,
    this.pPriseAvant,
    this.pPriseApres,
    this.pPassageCableAvant,
    this.pPassageCableApres,
    this.pCassetteRecto,
    this.pCassetteVerso,
    this.pSpeedTest,
    this.pDosRouteurCin,
    this.pNapFatBbOuvert,
    this.pNapFatBbFerme,
    this.pSlimboxOuvert,
    this.pSlimboxFerme,
    this.etatProvisioningId,
    this.commentaire,
    this.archiveId,
    this.created,
    this.etatName,
    this.type,
    this.plaqueName,
    this.commentaires,
  });

  factory Demande.fromJson(Map<String, dynamic> json) {
    return Demande(
      id: json['id'],
      userId: json['user_id'],
      numero: json['numero'],
      parent: json['parent'],
      numeroLigne: json['numero_ligne'],
      plaqueId: json['plaque_id'],
      groupeAffectation: json['groupe_affectation'],
      idCommande: json['id_commande'],
      consommateur: json['consommateur'],
      telMobile: json['tel_mobile'],
      createdSource: json['created_source'],
      adresseComplement1: json['adresse_complement1'],
      ftthSn: json['ftth_sn'],
      snRouteur: json['sn_routeur'],
      adresseMac: json['adresse_mac'],
      refRouteur: json['ref_routeur'],
      description: json['description'],
      numIdentification: json['num_identification'],
      fournisseur: json['fournisseur'],
      dateResolution: json['date_resolution'],
      etatId: json['etat_id'],
      subStatutId: json['sub_statut_id'],
      dateRdv: json['date_rdv'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      offreId: json['offre_id'],
      articleId: json['article_id'],
      cableFibre: json['cable_fibre'],
      boiteTypeId: json['boite_type_id'],
      numFat: json['num_fat'],
      numSplitter: json['num_splitter'],
      numSlimbox: json['num_slimbox'],
      positionId: json['position_id'],
      speedUpload: json['speed_upload'],
      speedDownload: json['speed_download'],
      signatureClient: json['signature_client'],
      pRouteurAllume: json['p_routeur_allume'],
      pTestSignalViaPm: json['p_test_signal_via_pm'],
      pPriseAvant: json['p_prise_avant'],
      pPriseApres: json['p_prise_apres'],
      pPassageCableAvant: json['p_passage_cable_avant'],
      pPassageCableApres: json['p_passage_cable_apres'],
      pCassetteRecto: json['p_cassette_recto'],
      pCassetteVerso: json['p_cassette_verso'],
      pSpeedTest: json['p_speed_test'],
      pDosRouteurCin: json['p_dos_routeur_cin'],
      pNapFatBbOuvert: json['p_nap_fat_bb_ouvert'],
      pNapFatBbFerme: json['p_nap_fat_bb_ferme'],
      pSlimboxOuvert: json['p_slimbox_ouvert'],
      pSlimboxFerme: json['p_slimbox_ferme'],
      etatProvisioningId: json['etat_provisioning_id'],
      commentaire: json['commentaire'],
      archiveId: json['archive_id'],
      created: json['created'],
      etatName: json['etat_name'],
      type: json['type'],
      plaqueName: json['plaque_name'],
      commentaires: json['commentaires'] != null
          ? (json['commentaires'] as List)
              .map((e) => Commentaire.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'numero': numero,
      'parent': parent,
      'numero_ligne': numeroLigne,
      'plaque_id': plaqueId,
      'groupe_affectation': groupeAffectation,
      'id_commande': idCommande,
      'consommateur': consommateur,
      'tel_mobile': telMobile,
      'created_source': createdSource,
      'adresse_complement1': adresseComplement1,
      'ftth_sn': ftthSn,
      'sn_routeur': snRouteur,
      'adresse_mac': adresseMac,
      'ref_routeur': refRouteur,
      'description': description,
      'num_identification': numIdentification,
      'fournisseur': fournisseur,
      'date_resolution': dateResolution,
      'etat_id': etatId,
      'sub_statut_id': subStatutId,
      'date_rdv': dateRdv,
      'longitude': longitude,
      'latitude': latitude,
      'offre_id': offreId,
      'article_id': articleId,
      'cable_fibre': cableFibre,
      'boite_type_id': boiteTypeId,
      'num_fat': numFat,
      'num_splitter': numSplitter,
      'num_slimbox': numSlimbox,
      'position_id': positionId,
      'speed_upload': speedUpload,
      'speed_download': speedDownload,
      'signature_client': signatureClient,
      'p_routeur_allume': pRouteurAllume,
      'p_test_signal_via_pm': pTestSignalViaPm,
      'p_prise_avant': pPriseAvant,
      'p_prise_apres': pPriseApres,
      'p_passage_cable_avant': pPassageCableAvant,
      'p_passage_cable_apres': pPassageCableApres,
      'p_cassette_recto': pCassetteRecto,
      'p_cassette_verso': pCassetteVerso,
      'p_speed_test': pSpeedTest,
      'p_dos_routeur_cin': pDosRouteurCin,
      'p_nap_fat_bb_ouvert': pNapFatBbOuvert,
      'p_nap_fat_bb_ferme': pNapFatBbFerme,
      'p_slimbox_ouvert': pSlimboxOuvert,
      'p_slimbox_ferme': pSlimboxFerme,
      'etat_provisioning_id': etatProvisioningId,
      'commentaire': commentaire,
      'archive_id': archiveId,
      'created': created,
      'etat_name': etatName,
      'type': type,
      'plaque_name': plaqueName,
      'commentaires': commentaires?.map((e) => e.toJson()).toList(),

    };
  }
}

class Commentaire {
  String? id;
  String? userId;
  String? demandeId;
  String? commentaire;
  String? created;

  Commentaire({
    this.id,
    this.userId,
    this.demandeId,
    this.commentaire,
    this.created,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      id: json['id'],
      userId: json['user_id'],
      demandeId: json['demande_id'],
      commentaire: json['commentaire'],
      created: json['created'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'demande_id': demandeId,
      'commentaire': commentaire,
      'created': created,
    };
  }
}
