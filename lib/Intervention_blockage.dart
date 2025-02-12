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
import 'package:timelines_plus/timelines_plus.dart';

import 'Intervention.dart';

final GlobalKey<ScaffoldState> formStepperScaffoldKey =
new GlobalKey<ScaffoldState>();


class InterventionBlockageFormBLoc extends FormBloc<String, String> {
  // late final ResponseGetListEtat responseListEtat;
  // late final ResponseGetListType responseGetListType;
  late final ResponseGetListEtats responseGetListEtats;
  late final ResponseGetFieldOptions responseGetFieldOptions;

  Directory dir = Directory("");
  File fileTraitementList = File("");

  /* Form Fields */

  final motifDuBlocageDropDown = SelectFieldBloc<FieldOption, dynamic>(
    name: "Blockage[sub_statut_id]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) => value?.id,
  );

  final cableFibreTextField = TextFieldBloc(
    name: 'Blockage[cable]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final boitierTextField = TextFieldBloc(
    name: 'Blockage[boitier]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final tubeTextField = TextFieldBloc(
    name: 'Blockage[tube]',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final gcTradeBooleanFieldBloc = BooleanFieldBloc(
    name: 'Blockage[gc_trad]',
    initialValue: false,
  );
  final gcExisteBooleanFieldBloc = BooleanFieldBloc(
    name: 'Blockage[gc_existe]',
    initialValue: false,
  );
  final gcBooleanFieldBloc = BooleanFieldBloc(
    name: 'Blockage[gc]',
    initialValue: false,
  );
  final bPrBooleanFieldBloc = BooleanFieldBloc(
    name: 'Blockage[b_pr]',
    initialValue: false,
  );
  final paBooleanFieldBloc = BooleanFieldBloc(
    name: 'Blockage[pa]',
    initialValue: false,
  );
  final fixationBooleanFieldBloc = BooleanFieldBloc(
    name: 'Blockage[fixation]',
    initialValue: false,
  );


  final InputFieldBloc<XFile?, Object> pTraceAvant_1_inputFieldBloc =
  InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_trace_avant_1]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> pTraceAvant_2_inputFieldBloc =
  InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_trace_avant_2]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> pTraceAvant_3_inputFieldBloc =
  InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_trace_avant_3]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> pTraceAvant_4_inputFieldBloc =
  InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_trace_avant_4]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> pTraceApres_1_InputFieldBloc =
  InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_trace_apres_1]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> pTraceApres_2_InputFieldBloc =
  InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_trace_apres_2]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> pTraceApres_3_InputFieldBloc =
  InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_trace_apres_3]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> pTraceApres_4_InputFieldBloc =
  InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_trace_apres_4]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?,
      Object> pPositionPlan_1_InputFieldBloc = InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_position_plan_1]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  final InputFieldBloc<XFile?, Object> pPositionPlan_2_FieldBloc =
  InputFieldBloc(
    initialValue: null,
    name: "Blockage[p_position_plan_2]",
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
    name: "Blockage[signature]",
    validators: [
      FieldBlocValidators.required,
    ],
    toJson: (value) {
      MultipartFile file = MultipartFile.fromFileSync(value?.path ?? "",
          filename: value?.name ?? "");
      return file;
    },
  );

  InterventionBlockageFormBLoc() : super(isLoading: true) {
    Tools.currentStep = (Tools.selectedDemande?.etape ?? 1) - 1;

    print("Tools.currentStep ==> ${Tools.currentStep}");
    emit(FormBlocLoading(currentStep: Tools.currentStep));

    addFieldBlocs(
      step: 0,
      fieldBlocs: [
        motifDuBlocageDropDown,
        cableFibreTextField,
        boitierTextField,
        tubeTextField,
        gcTradeBooleanFieldBloc,
        gcExisteBooleanFieldBloc,
        gcBooleanFieldBloc,
        bPrBooleanFieldBloc,
        paBooleanFieldBloc,
        fixationBooleanFieldBloc,
        pTraceAvant_1_inputFieldBloc,
        pTraceAvant_2_inputFieldBloc,
        pTraceAvant_3_inputFieldBloc,
        pTraceAvant_4_inputFieldBloc,
        pTraceApres_1_InputFieldBloc,
        pTraceApres_2_InputFieldBloc,
        pTraceApres_3_InputFieldBloc,
        pTraceApres_4_InputFieldBloc,
        pPositionPlan_1_InputFieldBloc,
        pPositionPlan_2_FieldBloc,
        signatureInputFieldBloc
      ],
    );
  }

  @override
  void onLoading() async {
    Tools.initFiles();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      fileTraitementList = new File(dir.path + "/fileTraitementList.json");

      if (!fileTraitementList.existsSync()) {
        fileTraitementList.createSync();
      }
    });
    try {
      responseGetFieldOptions = await Tools.getFieldOptionsFromLocalAndInternet();
      // Update dropdowns
      updateDropdownItems(
        fieldOptions: responseGetFieldOptions.fieldOptions,
        dropdown: motifDuBlocageDropDown,
        key: 'substatut',
      );
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
      print("[INFO] Sending POST request to /traitements/blockage_mobile");
      Dio dio = Dio()
        ..interceptors.add(CustomInterceptor())
        ..interceptors.add(dioLoggerInterceptor);

      final apiResponse = await dio.post(
        "${Tools.baseUrl}/traitements/blockage_mobile",
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
      pTraceAvant_1_inputFieldBloc.name: pTraceAvant_1_inputFieldBloc,
      pTraceAvant_2_inputFieldBloc.name: pTraceAvant_2_inputFieldBloc,
      pTraceAvant_3_inputFieldBloc.name: pTraceAvant_3_inputFieldBloc,
      pTraceAvant_4_inputFieldBloc.name: pTraceAvant_4_inputFieldBloc,
      pTraceApres_1_InputFieldBloc.name: pTraceApres_1_InputFieldBloc,
      pTraceApres_2_InputFieldBloc.name: pTraceApres_2_InputFieldBloc,
      pTraceApres_3_InputFieldBloc.name: pTraceApres_3_InputFieldBloc,
      pTraceApres_4_InputFieldBloc.name: pTraceApres_4_InputFieldBloc,
      pPositionPlan_1_InputFieldBloc.name: pPositionPlan_1_InputFieldBloc,
      pPositionPlan_2_FieldBloc.name: pPositionPlan_2_FieldBloc,
    };

    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

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

      formDateValues.addAll({
        // "etape": Tools.currentStep + 1,
        "demande_id": Tools.selectedDemande?.id ?? "",
        "user_id": Tools.userId,
        "date": dateNowFormatted,
        "currentAddress": currentAddress,
        // "Traitement[commentaire_sup]": "commentaire_sup"
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
        emitFailure(failureResponse: "sameStep");
        // emitSuccess();
      }

      // readJson();
    } catch (e) {
      emitFailure();
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
      pTraceAvant_1_inputFieldBloc: Tools.selectedDemande?.pRouteurAllume,
      pTraceAvant_2_inputFieldBloc: Tools.selectedDemande?.pTestSignalViaPm,
      pTraceAvant_3_inputFieldBloc: Tools.selectedDemande?.pPriseAvant,
      pTraceAvant_4_inputFieldBloc: Tools.selectedDemande?.pPriseApres,
      pTraceApres_1_InputFieldBloc:
      Tools.selectedDemande?.pPassageCableAvant,
      pTraceApres_2_InputFieldBloc:
      Tools.selectedDemande?.pPassageCableApres,
      pTraceApres_3_InputFieldBloc: Tools.selectedDemande?.pCassetteRecto,
      pTraceApres_4_InputFieldBloc: Tools.selectedDemande?.pCassetteVerso,
      pPositionPlan_1_InputFieldBloc: Tools.selectedDemande?.pSpeedTest,
      pPositionPlan_2_FieldBloc: Tools.selectedDemande?.pDosRouteurCin,
      cableFibreTextField: Tools.selectedDemande?.cableFibre,
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
      motifDuBlocageDropDown: Tools.selectedDemande?.etatId,
    };

    dropdownMappings.forEach((dropdownBloc, selectedId) {
      if (selectedId != null) {
        print("Removing validators for dropdown: ${dropdownBloc.name}");
        dropdownBloc.removeValidators([FieldBlocValidators.required]);
      }
    });
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

class InterventionBlockageForm extends StatefulWidget {
  @override
  _InterventionBlockageFormState createState() => _InterventionBlockageFormState();
}

class _InterventionBlockageFormState extends State<InterventionBlockageForm>
    with SingleTickerProviderStateMixin {
  var _type = StepperType.horizontal;

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
                            onPress: () =>
                            _animationController.isCompleted
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
                  title: Text('Blockage'),
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
                  child: FormBlocListener<InterventionBlockageFormBLoc, String, String>(
                    onLoading: (context, state) {
                      print("FormBlocListener onLoading");
                      LoadingDialog.show(context);
                    },
                    onLoaded: (context, state) {
                      print("FormBlocListener onLoaded");
                      LoadingDialog.hide(context);
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
                      print("FormBlocListener onFailure");

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
                        StepperFormBlocBuilder<InterventionBlockageFormBLoc>(
                          formBloc: context.read<InterventionBlockageFormBLoc>(),
                          type: _type,
                          physics: ClampingScrollPhysics(),
                          // onStepCancel: (formBloc) {
                          //   print("Cancel clicked");
                          //
                          //
                          //
                          // },
                          controlsBuilder: (BuildContext context,
                              VoidCallback? onStepContinue,
                              VoidCallback? onStepCancel,
                              int step,
                              FormBloc formBloc,) {
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
                                            Theme
                                                .of(context)
                                                .primaryColor,
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
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
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

  FormBlocStep _step1(InterventionBlockageFormBLoc formBloc) {
    return FormBlocStep(
      title: Text('Intervention'),
      content: Column(
        children: <Widget>[
          InterventionHeaderInfoClientWidget(),
          buildSizedDivider(),
          InterventionHeaderInfoProjectWidget(),
          SizedBox(
            height: 20,
          ),
          buildSizedDivider(),
          DropdownFieldBlocBuilder<FieldOption>(
            selectFieldBloc: formBloc.motifDuBlocageDropDown,
            decoration: const InputDecoration(
              labelText: 'Motif du blocage :',
              prefixIcon: Icon(Icons.list),
            ),
            itemBuilder: (context, value) =>
                FieldItem(
                  child: Text(value.name ?? ""),
                ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.cableFibreTextField,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Cable (12/24/48/72/144)FO :",
              prefixIcon: Icon(Icons.cable),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.boitierTextField,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Boitier (12/24/48/72/144)FO :",
              prefixIcon: Icon(Icons.cable),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.tubeTextField,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Tube Galvanisé :",
              prefixIcon: Icon(Icons.cable),
            ),
          ),
          buildSizedDivider(),
          CheckboxFieldBlocBuilder(
            alignment: AlignmentDirectional.center,
            booleanFieldBloc: formBloc.gcTradeBooleanFieldBloc,
            body: Container(
              alignment: Alignment.centerLeft,
              child: Text('Besoin de GC traditionnels',
                style: TextStyle(fontFamily: "Roboto"),),
            ),
          ),
          CheckboxFieldBlocBuilder(
            alignment: AlignmentDirectional.center,
            booleanFieldBloc: formBloc.gcExisteBooleanFieldBloc,
            body: Container(
              alignment: Alignment.centerLeft,
              child: Text('GC Déjà existé :',
                style: TextStyle(fontFamily: "Roboto"),),
            ),
          ),
          CheckboxFieldBlocBuilder(
            alignment: AlignmentDirectional.center,
            booleanFieldBloc: formBloc.gcBooleanFieldBloc,
            body: Container(
              alignment: Alignment.centerLeft,
              child: Text('Besoin de GC :',
                style: TextStyle(fontFamily: "Roboto"),),
            ),
          ),
          CheckboxFieldBlocBuilder(
            alignment: AlignmentDirectional.center,
            booleanFieldBloc: formBloc.bPrBooleanFieldBloc,
            body: Container(
              alignment: Alignment.centerLeft,
              child: Text('Blocage Propriétaires :',
                style: TextStyle(fontFamily: "Roboto"),),
            ),
          ),
          CheckboxFieldBlocBuilder(
            alignment: AlignmentDirectional.center,
            booleanFieldBloc: formBloc.paBooleanFieldBloc,
            body: Container(
              alignment: Alignment.centerLeft,
              child: Text('Passage aérienne :',
                style: TextStyle(fontFamily: "Roboto"),),
            ),
          ),
          CheckboxFieldBlocBuilder(
            alignment: AlignmentDirectional.center,
            booleanFieldBloc: formBloc.fixationBooleanFieldBloc,
            body: Container(
              alignment: Alignment.centerLeft,
              child: Text('Accessoires de fixation :',
                style: TextStyle(fontFamily: "Roboto"),),
            ),
          ),
          buildSizedDivider(),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: ImageFieldBlocBuilder(
                      formBloc: formBloc,
                      fileFieldBloc: formBloc.pTraceAvant_1_inputFieldBloc,
                      labelText: "Trace avant 1 :",
                      iconField: Icon(Icons.image_not_supported),
                    ),
                  ),
                  Flexible(
                    child: ImageFieldBlocBuilder(
                      formBloc: formBloc,
                      fileFieldBloc: formBloc.pTraceAvant_2_inputFieldBloc,
                      labelText: "Trace avant 2 :",
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
                      fileFieldBloc: formBloc.pTraceAvant_3_inputFieldBloc,
                      labelText: "Trace avant 3 :",
                      iconField: Icon(Icons.image_not_supported),
                    ),
                  ),
                  Flexible(
                    child: ImageFieldBlocBuilder(
                      formBloc: formBloc,
                      fileFieldBloc: formBloc.pTraceAvant_4_inputFieldBloc,
                      labelText: "Trace avant 4 :",
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
                      fileFieldBloc: formBloc.pTraceApres_1_InputFieldBloc,
                      labelText: "Trace apres 1 :",
                      iconField: Icon(Icons.image_not_supported),
                    ),
                  ),
                  Flexible(
                    child: ImageFieldBlocBuilder(
                      formBloc: formBloc,
                      fileFieldBloc: formBloc.pTraceApres_2_InputFieldBloc,
                      labelText: "Trace apres 2 :",
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
                      fileFieldBloc: formBloc.pTraceApres_3_InputFieldBloc,
                      labelText: "Trace apres 3 :",
                      iconField: Icon(Icons.image_not_supported),
                    ),
                  ),
                  Flexible(
                    child: ImageFieldBlocBuilder(
                      formBloc: formBloc,
                      fileFieldBloc: formBloc.pTraceApres_4_InputFieldBloc,
                      labelText: "Trace apres 4 :",
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
                      fileFieldBloc: formBloc.pPositionPlan_1_InputFieldBloc,
                      labelText: "Position sur plan 1 :",
                      iconField: Icon(Icons.image_not_supported),
                    ),
                  ),
                  Flexible(
                    child: ImageFieldBlocBuilder(
                      formBloc: formBloc,
                      fileFieldBloc: formBloc.pPositionPlan_2_FieldBloc,
                      labelText: "Position sur plan 2 :",
                      iconField: Icon(Icons.image_not_supported),
                    ),
                  ),
                ],
              )),
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
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
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
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
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
                      contentsBuilder: (context, index) =>
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Tools.selectedDemande
                                  ?.commentaires?[index].commentaire ??
                                  ""),
                            ),
                          ),
                      oppositeContentsBuilder: (context, index) =>
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Column(
                                  children: [
                                    // Text(Tools.selectedDemande?.commentaires?[index].userId ?? ""),
                                    Text(Tools.selectedDemande
                                        ?.commentaires?[index]
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
                right: notificationCount
                    .toString()
                    .length >= 3 ? 15 : 25,
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

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
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
