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
  String id;
  String userId;
  String numero;
  String parent;
  String numeroLigne;
  String plaqueId;
  String groupeAffectation;
  String idCommande;
  String consommateur;
  String telMobile;
  String createdSource;
  String adresseComplement1;
  String ftthSn;
  String snRouteur;
  String adresseMac;
  String refRouteur;
  String description;
  String numIdentification;
  String fournisseur;
  String dateResolution;
  String etatId;
  String subStatutId;
  String dateRdv;
  String longitude;
  String latitude;
  String offreId;
  String articleId;
  String cableFibre;
  String boiteTypeId;
  String numFat;
  String numSplitter;
  String numSlimbox;
  String positionId;
  String speedUpload;
  String speedDownload;
  String pRouteurAllume;
  String pTestSignalViaPm;
  String pPriseAvant;
  String pPriseApres;
  String pPassageCableAvant;
  String pPassageCableApres;
  String pCassetteRecto;
  String pCassetteVerso;
  String pSpeedTest;
  String pDosRouteurCin;
  String pNapFatBbOuvert;
  String pNapFatBbFerme;
  String pSlimboxOuvert;
  String pSlimboxFerme;
  String etatProvisioningId;
  String commentaire;
  String cable;
  String boitier;
  String tube;
  String gcTrad;
  String gcExiste;
  String gc;
  String bPr;
  String pa;
  String fixation;
  String pTraceAvant1;
  String pTraceAvant2;
  String pTraceAvant3;
  String pTraceAvant4;
  String pTraceApres1;
  String pTraceApres2;
  String pTraceApres3;
  String pTraceApres4;
  String pPositionPlan1;
  String pPositionPlan2;
  String signature;
  String archiveId;
  String created;
  String etatName;
  String plaqueName;
  List<Commentaire> commentaires;
  var etape; // Keeping it dynamic since no structure provided

  Demande({
    required this.id,
    required this.userId,
    required this.numero,
    required this.parent,
    required this.numeroLigne,
    required this.plaqueId,
    required this.groupeAffectation,
    required this.idCommande,
    required this.consommateur,
    required this.telMobile,
    required this.createdSource,
    required this.adresseComplement1,
    required this.ftthSn,
    required this.snRouteur,
    required this.adresseMac,
    required this.refRouteur,
    required this.description,
    required this.numIdentification,
    required this.fournisseur,
    required this.dateResolution,
    required this.etatId,
    required this.subStatutId,
    required this.dateRdv,
    required this.longitude,
    required this.latitude,
    required this.offreId,
    required this.articleId,
    required this.cableFibre,
    required this.boiteTypeId,
    required this.numFat,
    required this.numSplitter,
    required this.numSlimbox,
    required this.positionId,
    required this.speedUpload,
    required this.speedDownload,
    required this.pRouteurAllume,
    required this.pTestSignalViaPm,
    required this.pPriseAvant,
    required this.pPriseApres,
    required this.pPassageCableAvant,
    required this.pPassageCableApres,
    required this.pCassetteRecto,
    required this.pCassetteVerso,
    required this.pSpeedTest,
    required this.pDosRouteurCin,
    required this.pNapFatBbOuvert,
    required this.pNapFatBbFerme,
    required this.pSlimboxOuvert,
    required this.pSlimboxFerme,
    required this.etatProvisioningId,
    required this.commentaire,
    required this.cable,
    required this.boitier,
    required this.tube,
    required this.gcTrad,
    required this.gcExiste,
    required this.gc,
    required this.bPr,
    required this.pa,
    required this.fixation,
    required this.pTraceAvant1,
    required this.pTraceAvant2,
    required this.pTraceAvant3,
    required this.pTraceAvant4,
    required this.pTraceApres1,
    required this.pTraceApres2,
    required this.pTraceApres3,
    required this.pTraceApres4,
    required this.pPositionPlan1,
    required this.pPositionPlan2,
    required this.signature,
    required this.archiveId,
    required this.created,
    required this.etatName,
    required this.plaqueName,
    required this.commentaires,
  });

  factory Demande.fromJson(Map<String, dynamic> json) {
    return Demande(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      numero: json['numero'] ?? '',
      parent: json['parent'] ?? '',
      numeroLigne: json['numero_ligne'] ?? '',
      plaqueId: json['plaque_id'] ?? '',
      groupeAffectation: json['groupe_affectation'] ?? '',
      idCommande: json['id_commande'] ?? '',
      consommateur: json['consommateur'] ?? '',
      telMobile: json['tel_mobile'] ?? '',
      createdSource: json['created_source'] ?? '',
      adresseComplement1: json['adresse_complement1'] ?? '',
      ftthSn: json['ftth_sn'] ?? '',
      snRouteur: json['sn_routeur'] ?? '',
      adresseMac: json['adresse_mac'] ?? '',
      refRouteur: json['ref_routeur'] ?? '',
      description: json['description'] ?? '',
      numIdentification: json['num_identification'] ?? '',
      fournisseur: json['fournisseur'] ?? '',
      dateResolution: json['date_resolution'] ?? '',
      etatId: json['etat_id'] ?? '',
      subStatutId: json['sub_statut_id'] ?? '',
      dateRdv: json['date_rdv'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      offreId: json['offre_id'] ?? '',
      articleId: json['article_id'] ?? '',
      cableFibre: json['cable_fibre'] ?? '',
      boiteTypeId: json['boite_type_id'] ?? '',
      numFat: json['num_fat'] ?? '',
      numSplitter: json['num_splitter'] ?? '',
      numSlimbox: json['num_slimbox'] ?? '',
      positionId: json['position_id'] ?? '',
      speedUpload: json['speed_upload'] ?? '',
      speedDownload: json['speed_download'] ?? '',
      pRouteurAllume: json['p_routeur_allume'] ?? '',
      pTestSignalViaPm: json['p_test_signal_via_pm'] ?? '',
      pPriseAvant: json['p_prise_avant'] ?? '',
      pPriseApres: json['p_prise_apres'] ?? '',
      pPassageCableAvant: json['p_passage_cable_avant'] ?? '',
      pPassageCableApres: json['p_passage_cable_apres'] ?? '',
      pCassetteRecto: json['p_cassette_recto'] ?? '',
      pCassetteVerso: json['p_cassette_verso'] ?? '',
      pSpeedTest: json['p_speed_test'] ?? '',
      pDosRouteurCin: json['p_dos_routeur_cin'] ?? '',
      pNapFatBbOuvert: json['p_nap_fat_bb_ouvert'] ?? '',
      pNapFatBbFerme: json['p_nap_fat_bb_ferme'] ?? '',
      pSlimboxOuvert: json['p_slimbox_ouvert'] ?? '',
      pSlimboxFerme: json['p_slimbox_ferme'] ?? '',
      etatProvisioningId: json['etat_provisioning_id'] ?? '',
      commentaire: json['commentaire'] ?? '',
      cable: json['cable'] ?? '',
      boitier: json['boitier'] ?? '',
      tube: json['tube'] ?? '',
      gcTrad: json['gc_trad'] ?? '',
      gcExiste: json['gc_existe'] ?? '',
      gc: json['gc'] ?? '',
      bPr: json['b_pr'] ?? '',
      pa: json['pa'] ?? '',
      fixation: json['fixation'] ?? '',
      pTraceAvant1: json['p_trace_avant_1'] ?? '',
      pTraceAvant2: json['p_trace_avant_2'] ?? '',
      pTraceAvant3: json['p_trace_avant_3'] ?? '',
      pTraceAvant4: json['p_trace_avant_4'] ?? '',
      pTraceApres1: json['p_trace_apres_1'] ?? '',
      pTraceApres2: json['p_trace_apres_2'] ?? '',
      pTraceApres3: json['p_trace_apres_3'] ?? '',
      pTraceApres4: json['p_trace_apres_4'] ?? '',
      pPositionPlan1: json['p_position_plan_1'] ?? '',
      pPositionPlan2: json['p_position_plan_2'] ?? '',
      signature: json['signature'] ?? '',
      archiveId: json['archive_id'] ?? '',
      created: json['created'] ?? '',
      etatName: json['etat_name'] ?? '',
      plaqueName: json['plaque_name'] ?? '',
      commentaires: (json['commentaires'] as List<dynamic>)
          .map((comment) => Commentaire.fromJson(comment))
          .toList(),
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
      'cable': cable,
      'boitier': boitier,
      'tube': tube,
      'gc_trad': gcTrad,
      'gc_existe': gcExiste,
      'gc': gc,
      'b_pr': bPr,
      'pa': pa,
      'fixation': fixation,
      'p_trace_avant_1': pTraceAvant1,
      'p_trace_avant_2': pTraceAvant2,
      'p_trace_avant_3': pTraceAvant3,
      'p_trace_avant_4': pTraceAvant4,
      'p_trace_apres_1': pTraceApres1,
      'p_trace_apres_2': pTraceApres2,
      'p_trace_apres_3': pTraceApres3,
      'p_trace_apres_4': pTraceApres4,
      'p_position_plan_1': pPositionPlan1,
      'p_position_plan_2': pPositionPlan2,
      'signature': signature,
      'archive_id': archiveId,
      'created': created,
      'etat_name': etatName,
      'plaque_name': plaqueName,
      'commentaires': commentaires.map((comment) => comment.toJson()).toList(),
    };
  }
}

class Commentaire {
  String id;
  String userId;
  String demandeId;
  String commentaire;
  String created;

  Commentaire({
    required this.id,
    required this.userId,
    required this.demandeId,
    required this.commentaire,
    required this.created,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      demandeId: json['demande_id'] ?? '',
      commentaire: json['commentaire'] ?? '',
      created: json['created'] ?? '',
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