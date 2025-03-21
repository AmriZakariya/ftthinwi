import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';

// import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_social_share_plugin/flutter_social_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as imagePLugin;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telcabo/Tools.dart';
import 'package:telcabo/ToolsExtra.dart';
import 'package:telcabo/custome/ConnectivityCheckBlocBuilder.dart';
import 'package:telcabo/custome/ImageFieldBlocbuilder.dart';
import 'package:telcabo/custome/QrScannerTextFieldBlocBuilder.dart';
import 'package:telcabo/custome/SignatureFieldBlocBuilder.dart';
import 'package:telcabo/models/response_get_list_field_options.dart';
import 'package:telcabo/models/response_get_liste_etats.dart';
import 'package:telcabo/models/response_get_liste_pannes.dart';
import 'package:telcabo/ui/InterventionHeaderInfoWidget.dart';
import 'package:telcabo/ui/LoadingDialog.dart';
import 'package:telcabo/ui/SuccessScreen.dart';
import 'package:timelines_plus/timelines_plus.dart';

import 'Intervention_blockage.dart';

final GlobalKey<ScaffoldState> formStepperScaffoldKey =
    new GlobalKey<ScaffoldState>();

ValueNotifier<int> currentStepValueNotifier = ValueNotifier(Tools.currentStep);

class InterventionFormBLoc extends FormBloc<String, String> {
  // late final ResponseGetListEtat responseListEtat;
  // late final ResponseGetListType responseGetListType;
  late final ResponseGetListEtats responseGetListEtats;
  late final ResponseGetFieldOptions responseGetFieldOptions;

  Directory dir = Directory("");
  File fileTraitementList = File("");

  /* Form Fields */

  final etatsDropDown = SelectFieldBloc<Etat, dynamic>(
    name: "Traitement[etat_id]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) => value?.id,
  );

  final sousEtatsDropDown = SelectFieldBloc<SousEtat, dynamic>(
    name: "Traitement[sub_statut_id]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) => value?.id,
  );

  final offreDropDown = SelectFieldBloc<FieldOption, dynamic>(
    name: "Traitement[offre_id]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) => value?.id,
  );

  final articleDropDown = SelectFieldBloc<FieldOption, dynamic>(
    name: "Traitement[article_id]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) => value?.id,
  );

  final boiteTypeDropDown = SelectFieldBloc<FieldOption, dynamic>(
    name: "Traitement[boite_type_id]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) => value?.id,
  );

  final positionDropDown = SelectFieldBloc<FieldOption, dynamic>(
    name: "Traitement[position_id]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) => value?.id,
  );

  final etatProvisioningDropDown = SelectFieldBloc<FieldOption, dynamic>(
    name: "Traitement[etat_provisioning_id]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) => value?.id,
  );

  final cableFibreTextField = TextFieldBloc(
    name: 'Traitement[cable_fibre]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final numFatTextField = TextFieldBloc(
    name: 'Traitement[num_fat]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final numSplitterTextField = SelectFieldBloc(
    name: 'Traitement[num_splitter]',
    validators: [
      FieldBlocValidators.required,
    ],
    items: ["1", "2", "3", "4", "5"],
  );

  final numSlimboxTextField = TextFieldBloc(
    name: 'Traitement[num_slimbox]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final speedUploadTextField = TextFieldBloc(
    name: 'Traitement[speed_upload]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final speedDownloadTextField = TextFieldBloc(
    name: 'Traitement[speed_download]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final commentaireTextField = TextFieldBloc(
    name: 'Traitement[commentaire]',
    validators: [],
  );

  final InputFieldBloc<XFile?, Object> routeurAllumeInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_routeur_allume",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> testSignalViaPmInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_test_signal_via_pm",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> priseAvantInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_prise_avant",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> priseApresInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_prise_apres",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> passageCableAvantInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_passage_cable_avant",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> passageCableApresInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_passage_cable_apres",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> cassetteRectoInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_cassette_recto",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> cassetteVersoInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_cassette_verso",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> speedTestInputFieldBloc = InputFieldBloc(
    initialValue: null,
    name: "p_speed_test",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> dosRouteurCinInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_dos_routeur_cin",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> napFatBbOuvertInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_nap_fat_bb_ouvert",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> napFatBbFermeInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_nap_fat_bb_ferme",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> slimboxOuvertInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_slimbox_ouvert",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> slimboxFermeInputFieldBloc =
      InputFieldBloc(
    initialValue: null,
    name: "p_slimbox_ferme",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> signatureInputFieldBloc = InputFieldBloc(
    initialValue: null,
    name: "signature",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final latitudeTextField = TextFieldBloc(
    name: 'Traitement[latitude]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final longintudeTextField = TextFieldBloc(
    name: 'Traitement[longitude]',
    validators: [
      FieldBlocValidators.required,
    ],
  );
  final adresseMacTextField = TextFieldBloc(
    name: 'Traitement[adresse_mac]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final snRouteurTextField = TextFieldBloc(
    name: 'Traitement[sn_routeur]',
    validators: [
      //FieldBlocValidators.required,
    ],
  );

  final refRouteurTextField = TextFieldBloc(
    name: 'Traitement[ref_routeur]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final dateRdvInputFieldBLoc = InputFieldBloc<DateTime?, Object>(
    initialValue: null,
    name: "date_rdv",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:s');
      final String formatted = formatter.format(value ?? DateTime.now());
      return formatted;
    },
  );

  // DateFormat('yyyy-MM-dd HH:mm:s')
  var dateDebutInstallation  = DateFormat('yyyy-MM-dd HH:mm:s').format(DateTime.now());

  InterventionFormBLoc() : super(isLoading: true) {
    Tools.currentStep = (Tools.selectedDemande?.etape ?? 1) - 1;

    print("Tools.currentStep ==> ${Tools.currentStep}");
    emit(FormBlocLoading(currentStep: Tools.currentStep));

    addFieldBlocs(
      step: 0,
      fieldBlocs: [
        etatsDropDown,
        offreDropDown,
        articleDropDown,
        boiteTypeDropDown,
        positionDropDown,
        latitudeTextField,
        cableFibreTextField,
        numFatTextField,
        numSplitterTextField,
        speedUploadTextField,
        speedDownloadTextField,
        longintudeTextField,
        commentaireTextField,
        adresseMacTextField,
        snRouteurTextField,
        refRouteurTextField,
        // dateRdvInputFieldBLoc,
        routeurAllumeInputFieldBloc,
        testSignalViaPmInputFieldBloc,
        priseAvantInputFieldBloc,
        priseApresInputFieldBloc,
        passageCableAvantInputFieldBloc,
        passageCableApresInputFieldBloc,
        cassetteRectoInputFieldBloc,
        cassetteVersoInputFieldBloc,
        speedTestInputFieldBloc,
        dosRouteurCinInputFieldBloc,
        napFatBbOuvertInputFieldBloc,
        napFatBbFermeInputFieldBloc,
        slimboxOuvertInputFieldBloc,
        slimboxFermeInputFieldBloc,
        signatureInputFieldBloc
      ],
    );

    etatsDropDown.onValueChanges(
      onData: (previous, current) async* {
        var selectedEtat = current.value;
        print("selectedEtat id ==> ${selectedEtat?.id}");
        print("selectedEtat name ==> ${selectedEtat?.name}");
        if (selectedEtat?.id == null) {
          return;
        }

        removeFieldBlocs(
            fieldBlocs: [sousEtatsDropDown, etatProvisioningDropDown]);

        if (selectedEtat?.id == "8") {
          addFieldBloc(fieldBloc: etatProvisioningDropDown);
        }
        if (selectedEtat?.id == "12" && Tools.selectedDemande?.etatId != "12") {
          print("selectedEtat contain BLOC");
          emit(FormBlocFailure(currentStep: Tools.currentStep, isValidByStep: {}, failureResponse: "blockage"));
          return;
        }

        // chek if null or empty sub list
        if (selectedEtat?.sousEtats == null ||
            selectedEtat?.sousEtats?.isEmpty == true) {
          return;
        }

        sousEtatsDropDown.updateItems(selectedEtat?.sousEtats ?? []);
        addFieldBloc(fieldBloc: sousEtatsDropDown);

        // if (selectedEtat?.name?.toUpperCase().contains("BLOC") == true) {
        //   print("selectedEtat contain BLOC");
        //   emit(FormBlocFailure(currentStep: Tools.currentStep, isValidByStep: {}, failureResponse: "blockage"));
        //
        //   // navigator
        //   //     .push(
        //   //   MaterialPageRoute(
        //   //     builder: (_) => InterventionBlockageForm(),
        //   //   ),
        //   // )
        // }
      },
    );
  }

  bool writeToFileTraitementList(Map jsonMapContent) {
    print("Writing to writeToFileTraitementList!");

    try {
      final fieldBlocMapping = {
        routeurAllumeInputFieldBloc.name: routeurAllumeInputFieldBloc,
        testSignalViaPmInputFieldBloc.name: testSignalViaPmInputFieldBloc,
        priseAvantInputFieldBloc.name: priseAvantInputFieldBloc,
        priseApresInputFieldBloc.name: priseApresInputFieldBloc,
        passageCableAvantInputFieldBloc.name: passageCableAvantInputFieldBloc,
        passageCableApresInputFieldBloc.name: passageCableApresInputFieldBloc,
        cassetteRectoInputFieldBloc.name: cassetteRectoInputFieldBloc,
        cassetteVersoInputFieldBloc.name: cassetteVersoInputFieldBloc,
        speedTestInputFieldBloc.name: speedTestInputFieldBloc,
        dosRouteurCinInputFieldBloc.name: dosRouteurCinInputFieldBloc,
        napFatBbOuvertInputFieldBloc.name: napFatBbOuvertInputFieldBloc,
        napFatBbFermeInputFieldBloc.name: napFatBbFermeInputFieldBloc,
        slimboxOuvertInputFieldBloc.name: slimboxOuvertInputFieldBloc,
        slimboxFermeInputFieldBloc.name: slimboxFermeInputFieldBloc,
      };

      for (var mapKey in jsonMapContent.keys) {
        final fieldBloc = fieldBlocMapping[mapKey];
        if (fieldBloc != null) {
          jsonMapContent[mapKey] =
              "${fieldBloc.value?.path};;${fieldBloc.value?.name}";
        }
      }

      String fileContent = fileTraitementList.readAsStringSync();
      print("file content ==> ${fileContent}");

      if (fileContent.isEmpty) {
        print("empty file");

        Map emptyMap = {"traitementList": []};

        fileTraitementList.writeAsStringSync(json.encode(emptyMap));

        fileContent = fileTraitementList.readAsStringSync();
      }

      Map traitementListMap = json.decode(fileContent);

      print("file content decode ==> ${traitementListMap}");

      List traitementList = traitementListMap["traitementList"];

      traitementList.add(json.encode(jsonMapContent));

      traitementListMap["traitementList"] = traitementList;

      fileTraitementList.writeAsStringSync(json.encode(traitementListMap));

      return true;
    } catch (e) {
      print("exeption -- " + e.toString());
    }

    return false;
  }

  @override
  void onLoading() async {
    emitFailure(failureResponse: "loadingTest");
    Tools.initFiles();

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      fileTraitementList = new File(dir.path + "/fileTraitementList.json");

      if (!fileTraitementList.existsSync()) {
        fileTraitementList.createSync();
      }
    });

    try {
      responseGetListEtats = await Tools.getEtatsListFromLocalAndInternet();
      etatsDropDown.updateItems(responseGetListEtats.etats ?? []);

      responseGetFieldOptions =
          await Tools.getFieldOptionsFromLocalAndInternet();
      // Update dropdowns
      updateDropdownItems(
        fieldOptions: responseGetFieldOptions.fieldOptions,
        dropdown: offreDropDown,
        key: 'offre',
      );
      updateDropdownItems(
        fieldOptions: responseGetFieldOptions.fieldOptions,
        dropdown: articleDropDown,
        key: 'article',
      );
      updateDropdownItems(
        fieldOptions: responseGetFieldOptions.fieldOptions,
        dropdown: boiteTypeDropDown,
        key: 'boite_type',
      );
      updateDropdownItems(
        fieldOptions: responseGetFieldOptions.fieldOptions,
        dropdown: positionDropDown,
        key: 'position',
      );
      updateDropdownItems(
        fieldOptions: responseGetFieldOptions.fieldOptions,
        dropdown: etatProvisioningDropDown,
        key: 'etat_provisioning',
      );

      updateInputsFromDemande();
      updateValidatorFromDemande();

      emitLoaded();
    } catch (e) {
      print(e);
      emitLoadFailed(failureResponse: e.toString());
    }
  }



  void updateDropdownItems({
    required List<FieldOptionGroup> fieldOptions,
    required SelectFieldBloc dropdown,
    required String key,
  }) {
    final group = fieldOptions.firstWhere((g) => g.key == key,
        orElse: () => FieldOptionGroup(key: key, label: '', options: []));
    dropdown.updateItems(group.options);
  }

  @override
  void updateCurrentStep(int step) {
    print("override updateCurrentStep");
    print("Tools.currentStep ==> ${Tools.currentStep}");

    currentStepValueNotifier.value = Tools.currentStep;

    super.updateCurrentStep(step);
  }

  @override
  void previousStep() {
    print("override previousStep");
    print("Tools.currentStep ==> ${Tools.currentStep}");

    currentStepValueNotifier.value = Tools.currentStep;

    super.previousStep();
  }

  Future<String> callWsAddMobile(Map<String, dynamic> formDateValues) async {
    print("[INFO] callWsAddMobile invoked");

    if (Tools.localWatermark) {
      print("[INFO] Applying local watermark to images...");
      await applyLocalWatermark(formDateValues);
    } else {
      print("[INFO] Skipping local watermark application");
    }

    FormData formData = FormData.fromMap(formDateValues);
    print("[INFO] Form data prepared for submission");

    try {
      print("[INFO] Sending POST request to /traitements/add_mobile");
      Dio dio = Dio()
        ..interceptors.add(CustomInterceptor())
        ..interceptors.add(dioLoggerInterceptor);

      // print formData
      Tools.logFormData(formData);

      final apiResponse = await dio.post(
        "${Tools.baseUrl}/traitements/add_mobile",
        data: formData,
        options: Options(
          followRedirects: true,
          method: "POST",
          headers: {
            'Content-Type': 'multipart/form-data;charset=UTF-8',
            'Charset': 'utf-8',
            'Accept': 'application/json',
          },
        ),
      );

      print("[SUCCESS] API Response: ${apiResponse.data}");

      if (apiResponse.data.contains("000")) {
        print("[INFO] API response contains success code '000'");
        return "000";
      }
    } on DioError catch (dioError) {
      print("[ERROR] DioError: ${dioError.response ?? dioError.message}");
      return "Erreur de connexion au serveur";
    } catch (e) {
      print("[ERROR] Unexpected error: $e");
      return "Erreur de connexion au serveur";
    }

    print("[INFO] Returning default error response");
    return "Erreur de connexion au serveur";
  }

  Future<void> applyLocalWatermark(Map<String, dynamic> formDateValues) async {
    final inputFieldMap = {
      routeurAllumeInputFieldBloc.name: routeurAllumeInputFieldBloc,
      testSignalViaPmInputFieldBloc.name: testSignalViaPmInputFieldBloc,
      priseAvantInputFieldBloc.name: priseAvantInputFieldBloc,
      priseApresInputFieldBloc.name: priseApresInputFieldBloc,
      passageCableAvantInputFieldBloc.name: passageCableAvantInputFieldBloc,
      passageCableApresInputFieldBloc.name: passageCableApresInputFieldBloc,
      cassetteRectoInputFieldBloc.name: cassetteRectoInputFieldBloc,
      cassetteVersoInputFieldBloc.name: cassetteVersoInputFieldBloc,
      speedTestInputFieldBloc.name: speedTestInputFieldBloc,
      dosRouteurCinInputFieldBloc.name: dosRouteurCinInputFieldBloc,
      napFatBbOuvertInputFieldBloc.name: napFatBbOuvertInputFieldBloc,
      napFatBbFermeInputFieldBloc.name: napFatBbFermeInputFieldBloc,
      slimboxOuvertInputFieldBloc.name: slimboxOuvertInputFieldBloc,
      slimboxFermeInputFieldBloc.name: slimboxFermeInputFieldBloc,
    };

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    for (var mapKey in formDateValues.keys) {
      if (inputFieldMap.containsKey(mapKey)) {
        try {
          if (formDateValues[mapKey] != null) {
            var xfileSrc = inputFieldMap[mapKey]?.value;

            if (xfileSrc != null) {
              final fileResult = File(xfileSrc.path ?? "");
              final image =
                  imagePLugin.decodeImage(fileResult.readAsBytesSync());

              if (image != null) {
                final fileResultWithWatermark =
                    File('${dir.path}/$fileName.png');
                fileResultWithWatermark
                    .writeAsBytesSync(imagePLugin.encodePng(image));

                XFile xfileResult = XFile(fileResultWithWatermark.path);

                formDateValues[mapKey] = MultipartFile.fromFileSync(
                  xfileResult.path,
                  filename: xfileResult.name,
                );

                print("[SUCCESS] Watermark applied for $mapKey");
              }
            }
          }
        } catch (e) {
          print("[ERROR] Exception while processing $mapKey: $e");
          formDateValues[mapKey] = null;
        }
      } else {
        print(
            "[INFO] Skipping watermark for $mapKey as it is not in the allowed keys");
      }
    }
  }

  @override
  void onSubmitting() async {
    print("FormStepper onSubmitting() ");
    print("Tools.currentStep ==> ${Tools.currentStep}");
    print('onSubmittinga ${state.toJson()}');

    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:s');
      final String dateNowFormatted = formatter.format(DateTime.now());
      String currentAddress = "";

      bool isLocationServiceOK = await ToolsExtra.checkLocationService();
      if (isLocationServiceOK == false) {
        emitFailure(
            failureResponse: "Les services de localisation sont désactivés.");
        return;
      }

      try {
        currentAddress = await Tools.getAddressFromLatLng();
      } catch (e) {
        emitFailure(failureResponse: e.toString());
        return;
      }

      Map<String, dynamic> formDateValues = await state.toJson();

      var dateFinInstallation = DateFormat('yyyy-MM-dd HH:mm:s').format(DateTime.now());
      formDateValues.addAll({
        // "etape": Tools.currentStep + 1,
        "demande_id": Tools.selectedDemande?.id ?? "",
        "user_id": Tools.userId,
        "date": dateNowFormatted,
        "currentAddress": currentAddress,
        // "Traitement[commentaire_sup]": "commentaire_sup"
        "Traitement[date_debut_installation]": dateDebutInstallation,
        "Traitement[date_fin_installation]": dateFinInstallation
      });

      print(formDateValues);

      print("dio start");

      if (await Tools.tryConnection()) {
        String checkCallWs = await callWsAddMobile(formDateValues);

        if (checkCallWs == "000") {
          // if (await Tools.refreshSelectedDemande()) {
          await Tools.refreshSelectedDemande();
          print("refreshed refreshSelectedDemande");
          print("Tools.selectedDemande ==> ${Tools.selectedDemande?.etape}");
          print("state.currentStep ==> ${state.currentStep}");

          Tools.currentStep = (Tools.selectedDemande?.etape ?? 1) - 1;
          currentStepValueNotifier.value = Tools.currentStep;

          emitSuccess(canSubmitAgain: true);
          // }else {
          //   emitFailure(failureResponse: "WS");
          // }
        } else {
          // writeToFileTraitementList(formDateValues);

          emitFailure(failureResponse: checkCallWs);
        }
      } else {
        print('No internet :( Reason:');
        writeToFileTraitementList(formDateValues);
        emitFailure(failureResponse: "sameStep");
        // emitSuccess();
      }

      // readJson();
    } catch (e) {
      emitFailure();
    }
  }

  void updateInputsFromDemande() async {
    try {
      // Update text fields
      cableFibreTextField.updateValue(Tools.selectedDemande?.cableFibre ?? "");
      numFatTextField.updateValue(Tools.selectedDemande?.numFat ?? "");
      if (Tools.selectedDemande?.numSplitter != null &&
          ["1", "2", "3", "4", "5"].contains(Tools.selectedDemande!.numSplitter)) {
        numSplitterTextField.updateValue(Tools.selectedDemande!.numSplitter!);
      }
      numSlimboxTextField.updateValue(Tools.selectedDemande?.numSlimbox ?? "");
      speedUploadTextField
          .updateValue(Tools.selectedDemande?.speedUpload ?? "");
      speedDownloadTextField
          .updateValue(Tools.selectedDemande?.speedDownload ?? "");
      commentaireTextField
          .updateValue(Tools.selectedDemande?.commentaire ?? "");
      latitudeTextField.updateValue(Tools.selectedDemande?.latitude ?? "");
      longintudeTextField.updateValue(Tools.selectedDemande?.longitude ?? "");
      adresseMacTextField.updateValue(Tools.selectedDemande?.adresseMac ?? "");
      snRouteurTextField.updateValue(Tools.selectedDemande?.snRouteur ?? "");
      refRouteurTextField.updateValue(Tools.selectedDemande?.refRouteur ?? "");

      // Fetch and update dropdown lists
      print("selected etat ===== ${Tools.selectedDemande?.etatId}");
      Etat? selectedDropDown;

      try {
        selectedDropDown = responseGetListEtats.etats!.firstWhere(
          (etat) => etat.id == Tools.selectedDemande?.etatId,
        );
      } catch (e) {
        selectedDropDown = null; // Assign null if not found
        print(
            "No matching etat found for ID: ${Tools.selectedDemande?.etatId}");
      }

      etatsDropDown.updateValue(selectedDropDown);

      var responseGetFieldOptions =
          await Tools.getFieldOptionsFromLocalAndInternet();

      // Update dropdowns dynamically
      updateDropdownItemsData(
        fieldOptionGroups: responseGetFieldOptions.fieldOptions,
        dropdown: offreDropDown,
        key: 'offre',
        selectedId: Tools.selectedDemande?.offreId,
      );
      updateDropdownItemsData(
        fieldOptionGroups: responseGetFieldOptions.fieldOptions,
        dropdown: articleDropDown,
        key: 'article',
        selectedId: Tools.selectedDemande?.articleId,
      );
      updateDropdownItemsData(
        fieldOptionGroups: responseGetFieldOptions.fieldOptions,
        dropdown: boiteTypeDropDown,
        key: 'boite_type',
        selectedId: Tools.selectedDemande?.boiteTypeId,
      );
      updateDropdownItemsData(
        fieldOptionGroups: responseGetFieldOptions.fieldOptions,
        dropdown: positionDropDown,
        key: 'position',
        selectedId: Tools.selectedDemande?.positionId,
      );
      updateDropdownItemsData(
        fieldOptionGroups: responseGetFieldOptions.fieldOptions,
        dropdown: etatProvisioningDropDown,
        key: 'etat_provisioning',
        selectedId: Tools.selectedDemande?.etatProvisioningId,
      );

      // Update date field
      String? selectedRdvDate = Tools.selectedDemande?.dateRdv;
      if (selectedRdvDate?.isNotEmpty == true) {
        print("selected rdvDate ==> ${selectedRdvDate}");
        var parsedDate = DateTime.parse(selectedRdvDate!);
        dateRdvInputFieldBLoc.updateValue(parsedDate);
      }
    } catch (e) {
      print("Error while updating inputs from demande: ${e.toString()}");
      // Handle error (e.g., display error message or fallback behavior)
    }
  }

  void updateDropdownItemsData({
    required List<FieldOptionGroup> fieldOptionGroups,
    required SelectFieldBloc<FieldOption, dynamic> dropdown,
    required String key,
    String? selectedId,
  }) {
    // Find the field option group by key
    var fieldOptionGroup = fieldOptionGroups.firstWhere(
      (group) => group.key == key,
      orElse: () => FieldOptionGroup(key: key, label: '', options: []),
    );

    // Update dropdown items with options from the found group
    dropdown.updateItems(fieldOptionGroup.options);

    // Update the selected value if a matching ID exists
    if (selectedId != null) {
      var selectedOption = fieldOptionGroup.options.firstWhere(
        (option) => option.id == selectedId,
      );
      dropdown.updateValue(selectedOption);
    }
  }

  void updateValidatorFromDemande() {
    final validatorMappings = {
      routeurAllumeInputFieldBloc: Tools.selectedDemande?.pRouteurAllume,
      testSignalViaPmInputFieldBloc: Tools.selectedDemande?.pTestSignalViaPm,
      priseAvantInputFieldBloc: Tools.selectedDemande?.pPriseAvant,
      priseApresInputFieldBloc: Tools.selectedDemande?.pPriseApres,
      passageCableAvantInputFieldBloc:
          Tools.selectedDemande?.pPassageCableAvant,
      passageCableApresInputFieldBloc:
          Tools.selectedDemande?.pPassageCableApres,
      cassetteRectoInputFieldBloc: Tools.selectedDemande?.pCassetteRecto,
      cassetteVersoInputFieldBloc: Tools.selectedDemande?.pCassetteVerso,
      speedTestInputFieldBloc: Tools.selectedDemande?.pSpeedTest,
      dosRouteurCinInputFieldBloc: Tools.selectedDemande?.pDosRouteurCin,
      napFatBbOuvertInputFieldBloc: Tools.selectedDemande?.pNapFatBbOuvert,
      napFatBbFermeInputFieldBloc: Tools.selectedDemande?.pNapFatBbFerme,
      slimboxOuvertInputFieldBloc: Tools.selectedDemande?.pSlimboxOuvert,
      slimboxFermeInputFieldBloc: Tools.selectedDemande?.pSlimboxFerme,
      cableFibreTextField: Tools.selectedDemande?.cableFibre,
      numFatTextField: Tools.selectedDemande?.numFat,
      numSplitterTextField: Tools.selectedDemande?.numSplitter,
      numSlimboxTextField: Tools.selectedDemande?.numSlimbox,
      speedUploadTextField: Tools.selectedDemande?.speedUpload,
      speedDownloadTextField: Tools.selectedDemande?.speedDownload,
      latitudeTextField: Tools.selectedDemande?.latitude,
      longintudeTextField: Tools.selectedDemande?.longitude,
      adresseMacTextField: Tools.selectedDemande?.adresseMac,
      snRouteurTextField: Tools.selectedDemande?.snRouteur,
      refRouteurTextField: Tools.selectedDemande?.refRouteur,
    };

    validatorMappings.forEach((fieldBloc, value) {
      if (fieldBloc is TextFieldBloc) {
        if (value?.isNotEmpty == true) {
          print("Removing validators for field: ${fieldBloc.name}");
          (fieldBloc).removeValidators([FieldBlocValidators.required]);
        }
      } else if (fieldBloc is InputFieldBloc) {
        if (value?.isNotEmpty == true) {
          print("Removing validators for field: ${fieldBloc.name}");
          (fieldBloc).removeValidators([FieldBlocValidators.required]);
        }
      }
    });

    // Handle dropdown-specific validations
    final dropdownMappings = {
      etatsDropDown: Tools.selectedDemande?.etatId,
      sousEtatsDropDown: Tools.selectedDemande?.subStatutId,
      offreDropDown: Tools.selectedDemande?.offreId,
      articleDropDown: Tools.selectedDemande?.articleId,
      boiteTypeDropDown: Tools.selectedDemande?.boiteTypeId,
      positionDropDown: Tools.selectedDemande?.positionId,
      etatProvisioningDropDown: Tools.selectedDemande?.etatProvisioningId,
    };

    dropdownMappings.forEach((dropdownBloc, selectedId) {
      if (selectedId != null) {
        print("Removing validators for dropdown: ${dropdownBloc.name}");
        dropdownBloc.removeValidators([FieldBlocValidators.required]);
      }
    });

    // Handle date field validation
    if (Tools.selectedDemande?.dateRdv?.isNotEmpty == true) {
      print(
          "Removing validators for date field: ${dateRdvInputFieldBLoc.name}");
      dateRdvInputFieldBLoc.removeValidators([FieldBlocValidators.required]);
    }
  }
}

class CustomInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 302) {
      String? redirectUrl = response.headers.value('location');
      if (redirectUrl != null) {
        // Make a new request to the redirected URL
        var dio = Dio();
        var newResponse = await dio.post(
          redirectUrl,
          data: response.requestOptions.data,
          options: Options(
            headers: response.requestOptions.headers,
            followRedirects: true,
          ),
        );
        handler.resolve(newResponse);
        return;
      }
    }
    super.onResponse(response, handler);
  }
}

class InterventionForm extends StatefulWidget {
  final bool isFromBlocage;
  // Constructor with named parameter
  const InterventionForm({Key? key, required this.isFromBlocage}) : super(key: key);

  @override
  _InterventionFormState createState() => _InterventionFormState();
}

class _InterventionFormState extends State<InterventionForm>
    with SingleTickerProviderStateMixin {
  var _type = StepperType.horizontal;
  late NavigatorState navigator;

  Timer? _timer;
  int _elapsedTime = 0; // Tracks elapsed time in seconds
  bool _isRunning = false; // Tracks whether the timer is running

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _isRunning = true;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        setState(() {
          _elapsedTime++; // Increment elapsed time every second
        });
      },
    );
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel(); // Stop the timer
    });
  }

  @override
  void didChangeDependencies() {
    navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  void _toggleType() {
    setState(() {
      if (_type == StepperType.horizontal) {
        _type = StepperType.vertical;
      } else {
        _type = StepperType.horizontal;
      }
    });
  }

  ValueNotifier<int> commentaireCuuntValueNotifer =
      ValueNotifier(Tools.selectedDemande?.commentaires?.length ?? 0);

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InterventionFormBLoc>(
          create: (BuildContext context) => InterventionFormBLoc(),
        ),
        BlocProvider<InterventionBlockageFormBLoc>(
          create: (BuildContext context) => InterventionBlockageFormBLoc(),
        ),
        BlocProvider<InternetCubit>(
          create: (BuildContext context) =>
              InternetCubit(connectivity: Connectivity()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: MultiBlocListener(
              listeners: [
                BlocListener<InternetCubit, InternetState>(
                  listener: (context, state) {
                    if (state is InternetConnected) {
                      // showSimpleNotification(
                      //   Text("status : en ligne"),
                      //   // subtitle: Text("onlime"),
                      //   background: Colors.green,
                      //   duration: Duration(seconds: 5),
                      // );
                    }
                    if (state is InternetDisconnected) {
                      // showSimpleNotification(
                      //   Text("Offline"),
                      //   // subtitle: Text("onlime"),
                      //   background: Colors.red,
                      //   duration: Duration(seconds: 5),
                      // );
                    }
                  },
                ),
              ],
              child: Scaffold(
                key: formStepperScaffoldKey,
                resizeToAvoidBottomInset: true,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniStartFloat,

                //Init Floating Action Bubble
                floatingActionButton: ValueListenableBuilder(
                    valueListenable: currentStepValueNotifier,
                    builder: (BuildContext context, int currentStepNotifier,
                        Widget? child) {
                      print(
                          "ValueListenableBuilder ==> ${currentStepNotifier}");
                      return Visibility(
                          visible: currentStepNotifier != 1,
                          child: FloatingActionBubble(
                            // Menu items
                            items: <Bubble>[
                              // Floating action menu item
                              Bubble(
                                title: "WhatssApp",
                                iconColor: Colors.white,
                                bubbleColor: Colors.blue,
                                icon: FontAwesomeIcons.whatsapp,
                                titleStyle: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                onPress: () async {
                                  print("share wtsp");

                                  String msgShare =
                                      Tools.getMsgShare(currentStepNotifier);

                                  print("msgShare ==> ${msgShare}");

                                  // shareToWhatsApp({String msg,String imagePath})
                                  final FlutterSocialShare flutterShareMe =
                                      FlutterSocialShare();
                                  await flutterShareMe.shareToWhatsApp(
                                      msg: msgShare);

                                  /*
                          var whatsapp = "+212619993849";
                          var whatsappURl_android =
                              "whatsapp://send?phone=" + whatsapp + "&text=${Uri.parse(msgShare)}";
                          var whatappURL_ios =
                              "https://wa.me/$whatsapp?text=${Uri.parse(msgShare)}";
                          if (Platform.isIOS) {
                            // for iOS phone only
                            if (await canLaunch(whatappURL_ios)) {
                              await launch(whatappURL_ios, forceSafariVC: false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: new Text("whatsapp no installed")));
                            }
                          } else {
                            // android , web
                            if (await canLaunch(whatsappURl_android)) {
                              await launch(whatsappURl_android);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: new Text("whatsapp no installed")));
                            }
                          }

                           */
                                  _animationController.reverse();
                                },
                              ),
                              // Floating action menu item
                              Bubble(
                                title: "Mail",
                                iconColor: Colors.white,
                                bubbleColor: Colors.blue,
                                icon: Icons.mail_outline,
                                titleStyle: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                onPress: () async {
                                  LoadingDialog.show(context);
                                  bool success = await Tools.callWSSendMail();
                                  LoadingDialog.hide(context);

                                  if (success) {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Email Envoyé avec succès",
                                        autoCloseDuration: Duration(seconds: 5),
                                        title: "Succès");
                                  }
                                  _animationController.reverse();
                                },
                              ),
                              //Floating action menu item
                            ],

                            // animation controller
                            animation: _animation,

                            // On pressed change animation state
                            onPress: () => _animationController.isCompleted
                                ? _animationController.reverse()
                                : _animationController.forward(),

                            // Floating Action button Icon color
                            iconColor: Tools.colorSecondary,

                            // Flaoting Action button Icon
                            iconData: FontAwesomeIcons.whatsapp,
                            backGroundColor: Colors.white,
                          ));
                    }),

                appBar: AppBar(
                  leading: Builder(
                    builder: (BuildContext context) {
                      final ScaffoldState? scaffold = Scaffold.maybeOf(context);
                      final ModalRoute<Object?>? parentRoute =
                          ModalRoute.of(context);
                      final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
                      final bool canPop = parentRoute?.canPop ?? false;

                      if (hasEndDrawer && canPop) {
                        return BackButton();
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  title: Text('Intervention'),
                  actions: <Widget>[
                    // NamedIcon(
                    //     text: '',
                    //     iconData: _type == StepperType.horizontal
                    //         ? Icons.swap_vert
                    //         : Icons.swap_horiz,
                    //     onTap: _toggleType),
                    ValueListenableBuilder(
                      valueListenable: commentaireCuuntValueNotifer,
                      builder: (BuildContext context, int commentaireCount,
                          Widget? child) {
                        return NamedIcon(
                          text: '',
                          iconData: Icons.comment,
                          notificationCount: commentaireCount,
                          onTap: () {
                            formStepperScaffoldKey.currentState
                                ?.openEndDrawer();
                          },
                        );
                      },
                    )
                  ],
                ),
                endDrawer: EndDrawerWidget(),
                body: SafeArea(
                  child: FormBlocListener<InterventionFormBLoc, String, String>(
                    onLoading: (context, state) {
                      print("FormBlocListener onLoading");
                      LoadingDialog.show(context);
                    },
                    onLoaded: (context, state) {
                      print("FormBlocListener onLoaded");
                      LoadingDialog.hide(context);

                      if (Tools.selectedDemande?.etatId == "12") {
                        print("selectedEtat contain BLOC");
                        Tools.selectedBlockageEtatId = "12";
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => InterventionBlockageForm(),
                          ),
                        );
                      }
                    },
                    onLoadFailed: (context, state) {
                      print("FormBlocListener onLoadFailed");
                      LoadingDialog.hide(context);
                    },
                    onSubmissionCancelled: (context, state) {
                      print("FormBlocListener onSubmissionCancelled");
                      LoadingDialog.hide(context);
                    },
                    onSubmitting: (context, state) {
                      print("FormBlocListener onSubmitting");
                      LoadingDialog.show(context);
                    },
                    onSuccess: (context, state) {
                      print("FormBlocListener onSuccess");
                      LoadingDialog.hide(context);

                      commentaireCuuntValueNotifer.value =
                          Tools.selectedDemande?.commentaires?.length ?? 0;
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: "Enregistré avec succès",
                        // autoCloseDuration: Duration(seconds: 2),
                        title: "Succès",
                      );

                      Tools.currentStep = state.currentStep;

                      if (state.stepCompleted == state.lastStep) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => SuccessScreen()));
                      }
                    },
                    onFailure: (context, state) {
                      print(
                          "FormBlocListener onFailure ${state.failureResponse}");

                      if (state.failureResponse == "blockage") {
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => InterventionBlockageForm(),
                          ),
                        );
                        return;
                      }

                      if (state.failureResponse == "loadingTest") {
                        LoadingDialog.show(context);
                        return;
                      }

                      if (state.failureResponse == "loadingTestFinish") {
                        LoadingDialog.hide(context);
                        return;
                      }

                      LoadingDialog.hide(context);

                      if (state.failureResponse == "sameStep") {
                        commentaireCuuntValueNotifer.value =
                            Tools.selectedDemande?.commentaires?.length ?? 0;

                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          text: "Enregistré avec succès",
                          // autoCloseDuration: Duration(seconds: 2),
                          title: "Succès",
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.failureResponse!)));
                      }
                    },
                    onSubmissionFailed: (context, state) {
                      print("FormBlocListener onSubmissionFailed ${state}");
                      // LoadingDialog.hide(context);
                    },
                    child: Stack(
                      children: [
                        StepperFormBlocBuilder<InterventionFormBLoc>(
                          formBloc: context.read<InterventionFormBLoc>(),
                          type: _type,
                          physics: ClampingScrollPhysics(),
                          // onStepCancel: (formBloc) {
                          //   print("Cancel clicked");
                          //
                          //
                          //
                          // },
                          controlsBuilder: (
                            BuildContext context,
                            VoidCallback? onStepContinue,
                            VoidCallback? onStepCancel,
                            int step,
                            FormBloc formBloc,
                          ) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            print("Submit button clicked");
                                            formBloc
                                                .submit(); // Submit the form
                                          },
                                          child: const Text(
                                            'Enregistrer',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            // Button color
                                            foregroundColor: Colors.white,
                                            // Text color
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            minimumSize: const Size(280, 50),
                                            // Button size
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      30.0), // Rounded edges
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (!formBloc.state.isFirstStep &&
                                    !formBloc.state.isLastStep)
                                  const SizedBox(
                                    height: 50,
                                  ),
                              ],
                            );
                          },
                          stepsBuilder: (formBloc) {
                            return [
                              _step1(formBloc!),
                              // _step2(formBloc),
                              // _step3(formBloc),
                            ];
                          },
                          onStepTapped: (FormBloc? formBloc, int step) {
                            print("onStepTapped");
                            if (step >
                                (Tools.selectedDemande?.etape ?? 1) - 1) {
                              return;
                            }
                            Tools.currentStep = step;
                            print(formBloc);
                            formBloc?.updateCurrentStep(step);

                            // formBloc?.emit(FormBlocLoaded(currentStep: Tools.currentStep));
                          },
                        ),
                        BlocBuilder<InternetCubit, InternetState>(
                          builder: (context, state) {
                            print("BlocBuilder **** InternetCubit ${state}");
                            if (state is InternetConnected &&
                                state.connectionType == ConnectionType.wifi) {
                              // return Text(
                              //   'Wifi',
                              //   style: TextStyle(color: Colors.green, fontSize: 30),
                              // );
                            } else if (state is InternetConnected &&
                                state.connectionType == ConnectionType.mobile) {
                              // return Text(
                              //   'Mobile',
                              //   style: TextStyle(color: Colors.yellow, fontSize: 30),
                              // );
                            } else if (state is InternetDisconnected) {
                              return Positioned(
                                bottom: 0,
                                child: Center(
                                  child: Container(
                                    color: Colors.grey.shade400,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(0.0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Pas d'accès internet",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            // return CircularProgressIndicator();
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  // Method to create the custom title with elapsed time
  Widget _buildTitleWithTime() {
    // Format elapsed time into minutes and seconds
    String formatTime(int seconds) {
      int minutes = (seconds / 60).floor();
      int remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Intervention ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: ' (Durée ${formatTime(_elapsedTime)})', // Display time in MM:SS format
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  FormBlocStep _step1(InterventionFormBLoc formBloc) {
    return FormBlocStep(
      title: _buildTitleWithTime(), // Use the custom title widget here
      content: Column(
        children: <Widget>[
          InterventionHeaderInfoClientWidget(),
          buildSizedDivider(),
          InterventionHeaderInfoProjectWidget(),
          SizedBox(
            height: 20,
          ),
          buildSizedDivider(),
          DropdownFieldBlocBuilder<Etat>(
            selectFieldBloc: formBloc.etatsDropDown,
            decoration: const InputDecoration(
              labelText: 'Etat :',
              prefixIcon: Icon(Icons.list),
            ),
            itemBuilder: (context, value) => FieldItem(
              child: Text(value.name ?? ""),
            ),
          ),
          DropdownFieldBlocBuilder<SousEtat>(
            selectFieldBloc: formBloc.sousEtatsDropDown,
            decoration: const InputDecoration(
              labelText: 'Motif du blocage :',
              prefixIcon: Icon(Icons.list),
            ),
            itemBuilder: (context, value) => FieldItem(
              child: Text(value.name ?? ""),
            ),
          ),
          buildSizedDivider(),
          DropdownFieldBlocBuilder<FieldOption>(
            selectFieldBloc: formBloc.offreDropDown,
            decoration: const InputDecoration(
              labelText: 'Offre :',
              prefixIcon: Icon(Icons.list),
            ),
            itemBuilder: (context, value) => FieldItem(
              child: Text(value.name ?? ""),
            ),
          ),
          DropdownFieldBlocBuilder<FieldOption>(
            selectFieldBloc: formBloc.articleDropDown,
            decoration: const InputDecoration(
              labelText: 'Equipement :',
              prefixIcon: Icon(Icons.list),
            ),
            itemBuilder: (context, value) => FieldItem(
              child: Text(value.name ?? ""),
            ),
          ),
          DropdownFieldBlocBuilder<FieldOption>(
            selectFieldBloc: formBloc.boiteTypeDropDown,
            decoration: const InputDecoration(
              labelText: 'Boite type :',
              prefixIcon: Icon(Icons.list),
            ),
            itemBuilder: (context, value) => FieldItem(
              child: Text(value.name ?? ""),
            ),
          ),
          DropdownFieldBlocBuilder<FieldOption>(
            selectFieldBloc: formBloc.etatProvisioningDropDown,
            decoration: const InputDecoration(
              labelText: 'Etat provisioning :',
              prefixIcon: Icon(Icons.list),
            ),
            itemBuilder: (context, value) => FieldItem(
              child: Text(value.name ?? ""),
            ),
          ),
          buildSizedDivider(),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.cableFibreTextField,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Cable fibre :",
              prefixIcon: Icon(Icons.cable),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.numFatTextField,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Num fat :",
              prefixIcon: Icon(Icons.numbers),
            ),
          ),
          DropdownFieldBlocBuilder(
            selectFieldBloc: formBloc.numSplitterTextField,
            decoration: const InputDecoration(
              labelText: "Num splitter :",
              prefixIcon: Icon(Icons.scatter_plot),
            ),
            itemBuilder: (context, value) => FieldItem(
              child: Text(value),
            ),
          ),
          DropdownFieldBlocBuilder<FieldOption>(
            selectFieldBloc: formBloc.positionDropDown,
            decoration: const InputDecoration(
              labelText: 'position du brin splitter :',
              prefixIcon: Icon(Icons.list),
            ),
            itemBuilder: (context, value) => FieldItem(
              child: Text(value.name ?? ""),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.numSlimboxTextField,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Num slimbox :",
              prefixIcon: Icon(Icons.storage),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.speedUploadTextField,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: "Speed upload :",
              prefixIcon: Icon(Icons.upload),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.speedDownloadTextField,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: "Speed download :",
              prefixIcon: Icon(Icons.download),
            ),
          ),
          buildSizedDivider(),
          Container(
              child: Row(
            children: [
              Flexible(
                flex: 5,
                child: Container(
                  child: Column(
                    children: [
                      TextFieldBlocBuilder(
                        readOnly: true,
                        textFieldBloc: formBloc.latitudeTextField,
                        clearTextIcon: Icon(Icons.cancel),
                        suffixButton: SuffixButton.clearText,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Latitude ",
                          prefixIcon: Icon(Icons.location_on),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                // color: Tools.colorPrimary
                              ),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        readOnly: true,
                        textFieldBloc: formBloc.longintudeTextField,
                        keyboardType: TextInputType.text,
                        clearTextIcon: Icon(Icons.cancel),
                        suffixButton: SuffixButton.clearText,
                        decoration: InputDecoration(
                          labelText: "Longitude ",
                          prefixIcon: Icon(Icons.location_on),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                // color: Tools.colorPrimary
                              ),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                // flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      bool isLocationServiceOK =
                          await ToolsExtra.checkLocationService();
                      if (isLocationServiceOK == false) {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            text:
                                "Les services de localisation sont désactivés.",
                            autoCloseDuration: Duration(seconds: 5),
                            title: "Erreur");

                        return;
                      }

                      Position? position = await Tools.determinePosition();

                      if (position != null) {
                        formBloc.latitudeTextField
                            .updateValue(position.latitude.toStringAsFixed(4));
                        formBloc.longintudeTextField
                            .updateValue(position.longitude.toStringAsFixed(4));

                        print("heeeeeee 3 ${position}");
                      }
                    } catch (e) {
                      print(e);
                      // showSimpleNotification(
                      //   Text("Erreur"),
                      //   subtitle: Text(e.toString()),
                      //   background: Colors.green,
                      //   duration: Duration(seconds: 5),
                      // );

                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          text: e.toString(),
                          autoCloseDuration: Duration(seconds: 5),
                          title: "Erreur");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: Tools.colorPrimary,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                  ),
                  child: const Icon(Icons.my_location),
                ),
              ),
            ],
          )),
          buildSizedDivider(),
          QrScannerTextFieldBlocBuilder(
            formBloc: formBloc,
            iconField: Padding(
              padding: const EdgeInsets.only(top: 10, left: 12),
              child: FaIcon(
                FontAwesomeIcons.terminal,
              ),
            ),
            labelText: "Adresse Mac :",
            qrCodeTextFieldBloc: formBloc.adresseMacTextField,
          ),
          QrScannerTextFieldBlocBuilder(
            formBloc: formBloc,
            iconField: Padding(
              padding: const EdgeInsets.only(top: 10, left: 12),
              child: FaIcon(
                FontAwesomeIcons.terminal,
              ),
            ),
            labelText: "SN Routeur :",
            qrCodeTextFieldBloc: formBloc.snRouteurTextField,
          ),
          QrScannerTextFieldBlocBuilder(
            formBloc: formBloc,
            iconField: Padding(
              padding: const EdgeInsets.only(top: 10, left: 12),
              child: FaIcon(
                FontAwesomeIcons.terminal,
              ),
            ),
            labelText: "Ref routeur :",
            qrCodeTextFieldBloc: formBloc.refRouteurTextField,
          ),
          buildSizedDivider(),
          // DateTimeFieldBlocBuilder(
          //   dateTimeFieldBloc: formBloc.dateRdvInputFieldBLoc,
          //   format: DateFormat('yyyy-MM-dd HH:mm'),
          //   //  Y-m-d H:i:s
          //   initialDate: DateTime.now(),
          //   firstDate: DateTime.now(),
          //   lastDate: DateTime(2100),
          //   canSelectTime: true,
          //   decoration: const InputDecoration(
          //     labelText: 'Rendez-vous',
          //     prefixIcon: Icon(Icons.date_range),
          //   ),
          // ),
          // buildSizedDivider(),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.routeurAllumeInputFieldBloc,
                  labelText: "Routeur allumé :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.testSignalViaPmInputFieldBloc,
                  labelText: "Test signal via PM :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
            ],
          )),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.priseAvantInputFieldBloc,
                  labelText: "Prise avant :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.priseApresInputFieldBloc,
                  labelText: "Prise après :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
            ],
          )),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.passageCableAvantInputFieldBloc,
                  labelText: "Passage câble avant :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.passageCableApresInputFieldBloc,
                  labelText: "Passage câble après :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
            ],
          )),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.cassetteRectoInputFieldBloc,
                  labelText: "Cassette recto :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.cassetteVersoInputFieldBloc,
                  labelText: "Cassette verso :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
            ],
          )),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.speedTestInputFieldBloc,
                  labelText: "Speed test :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.dosRouteurCinInputFieldBloc,
                  labelText: "Dos routeur CIN :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
            ],
          )),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.napFatBbOuvertInputFieldBloc,
                  labelText: "NAP FAT BB ouvert :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.napFatBbFermeInputFieldBloc,
                  labelText: "NAP FAT BB fermé :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
            ],
          )),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.slimboxOuvertInputFieldBloc,
                  labelText: "Slimbox ouvert :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
              Flexible(
                child: ImageFieldBlocBuilder(
                  formBloc: formBloc,
                  fileFieldBloc: formBloc.slimboxFermeInputFieldBloc,
                  labelText: "Slimbox fermé :",
                  iconField: Icon(Icons.image_not_supported),
                ),
              ),
            ],
          )),
          buildSizedDivider(),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.commentaireTextField,
            keyboardType: TextInputType.text,
            minLines: 6,
            maxLines: 20,
            decoration: InputDecoration(
              labelText: "Commentaire :",
              prefixIcon: Icon(Icons.comment),
            ),
          ),
          buildSizedDivider(),
          SignatureFieldBlocBuilder(
            signatureFieldBloc: formBloc.signatureInputFieldBloc,
            formBloc: formBloc,
            labelText: "Signature :",
          ),
          buildSizedDivider(),
        ],
      ),
    );
  }

  Widget buildSizedDivider() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Colors.black,
          height: 2,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    print("new value ==> ${newValue.text}");
    if (newValue.text == '')
      return TextEditingValue();
    else if (double.parse(newValue.text) < -26)
      return TextEditingValue().copyWith(text: '-25.99');

    return double.parse(newValue.text) > -15
        ? TextEditingValue().copyWith(text: '-15')
        : newValue;
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    print("oldValue ==> ${oldValue.text}");
    print("newValue ==> ${newValue.text}");

    if (newValue.text == '-' && oldValue.text == '') {
      return newValue;
    }

    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}

class EndDrawerWidget extends StatelessWidget {
  const EndDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_home.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Commentaires"),
              ),
              Expanded(
                child: Scrollbar(
                  // isAlwaysShown: true,
                  child: Timeline.tileBuilder(
                    // physics: BouncingScrollPhysics(),
                    builder: TimelineTileBuilder.fromStyle(
                      contentsBuilder: (context, index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(Tools.selectedDemande
                                  ?.commentaires?[index].commentaire ??
                              ""),
                        ),
                      ),
                      oppositeContentsBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Column(
                              children: [
                                // Text(Tools.selectedDemande?.commentaires?[index].userId ?? ""),
                                Text(Tools.selectedDemande?.commentaires?[index]
                                        .created
                                        ?.trim() ??
                                    ""),
                              ],
                            )),
                      ),
                      // itemExtent: 1,
                      // indicatorPositionBuilder: (BuildContext context, int index){
                      //   return 0 ;
                      // },
                      contentsAlign: ContentsAlign.alternating,
                      indicatorStyle: IndicatorStyle.dot,
                      connectorStyle: ConnectorStyle.dashedLine,
                      itemCount:
                          Tools.selectedDemande?.commentaires?.length ?? 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback? onTap;
  final int notificationCount;

  const NamedIcon({
    Key? key,
    this.onTap,
    required this.text,
    required this.iconData,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData),
                Text(text, overflow: TextOverflow.ellipsis),
              ],
            ),
            if (notificationCount > 0)
              Positioned(
                top: 10,
                right: notificationCount.toString().length >= 3 ? 15 : 25,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  alignment: Alignment.center,
                  child: Text('$notificationCount'),
                ),
              )
          ],
        ),
      ),
    );
  }
}

typedef Validator = String? Function(String? value);

Validator minMaxValidator({required int min, required int max}) {
  return (String? value) {
    int intValue;

    try {
      intValue = int.parse(value ?? "");
      if (intValue < min) {
        return "Value should not be less than $min";
      }
      if (intValue > max) {
        return "Value should not be greater than $max";
      }
    } catch (e) {
      return "Please enter a valid number";
    }
    return null; // No error
  };
}
