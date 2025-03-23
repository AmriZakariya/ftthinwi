import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image/image.dart' as imagePlugin;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telcabo/DemandeList.dart';
import 'package:telcabo/custome/connectivity_check.dart';
import 'package:telcabo/models/response_get_demandes.dart';
import 'package:telcabo/models/response_get_list_field_options.dart';
import 'package:telcabo/models/response_get_liste_etats.dart';
import 'custome/response_get_list_users.dart';

/// Utility class for network calls, file handling, and data caching.
class Tools {
  static String baseUrl = "https://ftthinwi.castlit.com";
  static bool localWatermark = false;

  // Selected demande and cached data
  static Demande? selectedDemande;
  static ResponseGetDemandesList? demandesListSaved;

  // Common fields
  static int currentStep = 1;
  static String selectedBlockageEtatId = "12";
  static Map? searchFilter = {};
  static String currentDemandesEtatFilter = "";
  static String deviceToken = "";
  static String fcmToken = "";
  static String userId = "";
  static String userName = "";
  static String userEmail = "";
  static String roleId = "";

  // Demand states
  static const String EN_COURS = "1";
  static const String ANNULATION_CLIENT = "2";
  static const String ATTENTE_RETOUR_CLIENT = "3";
  static const String CLIENT_INJOIGNABLE = "4";
  static const String CONTACT_ERRONE = "5";
  static const String DOUBLON = "6";
  static const String ATTENTE_ACTIVATION = "7";
  static const String FIN_INSTALLATION = "8";
  static const String INTERVENTION_BLOQUEE = "9";
  static const String INSTALLATION_EN_COURS = "10";
  static const String PLANIFIEE = "11";
  static const String BLOCAGE_INSTALLATION = "12";

  static const List<Map<String, String>> etats = [
    {"title": "Demandes en cours", "etat": Tools.EN_COURS},
    {"title": "Annulation client", "etat": Tools.ANNULATION_CLIENT},
    {"title": "Attente retour client", "etat": Tools.ATTENTE_RETOUR_CLIENT},
    {"title": "Client injoignable", "etat": Tools.CLIENT_INJOIGNABLE},
    {"title": "Contact erroné", "etat": Tools.CONTACT_ERRONE},
    {"title": "Doublon", "etat": Tools.DOUBLON},
    {"title": "Attente activation", "etat": Tools.ATTENTE_ACTIVATION},
    {"title": "Fin installation", "etat": Tools.FIN_INSTALLATION},
    {"title": "Intervention bloquée", "etat": Tools.INTERVENTION_BLOQUEE},
    {"title": "Installation en cours", "etat": Tools.INSTALLATION_EN_COURS},
    {"title": "Planifiée", "etat": Tools.PLANIFIEE},
    {"title": "Blocage installation", "etat": Tools.BLOCAGE_INSTALLATION},
  ];


  // Language and colors
  static String languageCode = "ar";
  static final Color colorPrimary = const Color(0xff913776);
  static final Color colorSecondary = const Color(0xff5d234c);
  static final Color colorBackground = const Color(0xfff3f1ef);

  // Local files
  static File filePannesList = File("");
  static File fileEtatsList = File("");
  static File fileFieldOptions = File("");
  static File fileDemandesList = File("");
  static File fileTraitementList = File("");

  // Connectivity
  static ConnectivityResult? connectivityResult;

  /// Unified logging method for easier log filtering.
  static void _log(String message) {
    print("[Tools] $message");
  }

  /// Unified error logging method.
  static void _logError(String message,
      [dynamic error, StackTrace? stackTrace]) {
    print("[Tools:ERROR] $message");
    if (error != null) print("[Tools:ERROR] Error: $error");
    if (stackTrace != null) print("[Tools:ERROR] StackTrace: $stackTrace");
  }

  /// Gets a human-readable language name.
  static String getLanguageName() {
    switch (languageCode) {
      case "ar":
        return "العربية";
      case "fr":
        return "Français";
      default:
        return languageCode;
    }
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  // static List<User> user

  static List<User> userList = [];
  /// Initialize local files used for caching.
  static void initFiles() {
    _log("initFiles started");
    getApplicationDocumentsDirectory().then((Directory directory) {
      filePannesList = File("${directory.path}/filePannesList.json");
      fileEtatsList = File("${directory.path}/fileEtatsList.json");
      fileFieldOptions = File("${directory.path}/fileFieldOptions.json");
      fileDemandesList = File("${directory.path}/fileDemandesList.json");
      fileTraitementList = File("${directory.path}/fileTraitementList.json");

      if (!filePannesList.existsSync()) filePannesList.createSync();
      if (!fileEtatsList.existsSync()) fileEtatsList.createSync();
      if (!fileFieldOptions.existsSync()) fileFieldOptions.createSync();
      if (!fileDemandesList.existsSync()) fileDemandesList.createSync();
      if (!fileTraitementList.existsSync()) fileTraitementList.createSync();
    }).catchError((e) {
      _logError("initFiles exception", e);
    });
  }

  /// Attempts a network call and on failure returns fallback data.
  static Future<T> _callApiWithFallback<T>({
    required Future<T> Function() apiCall,
    required T Function() fallback,
    String apiName = "",
  }) async {
    _log("$apiName: API call started");
    try {
      return await apiCall();
    } catch (e) {
      _logError("$apiName: Exception caught", e);
      _log("$apiName: Falling back to local data");
      return fallback();
    }
  }

  /// Generic method to decode response data (assumes `response.data` is a JSON string).
  static dynamic _decodeResponseData(Response response, String apiName) {
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data.toString().isNotEmpty) {
      try {
        return jsonDecode(response.data);
      } catch (e) {
        _logError("$apiName: JSON decode error", e);
        return null;
      }
    } else {
      _logError("$apiName: Empty or invalid response");
      return null;
    }
  }

  static Future<ResponseGetListEtats> callWSGetEtats() async {
    Dio dio = Dio()..interceptors.add(dioLoggerInterceptor);
    return _callApiWithFallback<ResponseGetListEtats>(
      apiCall: () async {
        _log("callWSGetEtats: calling API");
        final response = await dio.get("$baseUrl/etats/liste_etats");
        final decoded = _decodeResponseData(response, "callWSGetEtats");
        if (decoded != null) {
          writeToFileEtatsList(decoded);
          return ResponseGetListEtats.fromJson(decoded);
        }
        throw Exception("Invalid response from server");
      },
      fallback: readfileEtatsList,
      apiName: "callWSGetEtats",
    );
  }

  static Future<ResponseGetFieldOptions> callWSGetFieldOptions() async {
    Dio dio = Dio()..interceptors.add(dioLoggerInterceptor);
    return _callApiWithFallback<ResponseGetFieldOptions>(
      apiCall: () async {
        _log("callWSGetFieldOptions: calling API");
        final response = await dio.get("$baseUrl/traitements/getFieldsOptions");
        final decoded = _decodeResponseData(response, "callWSGetFieldOptions");
        if (decoded != null && decoded is List) {
          writeToFileFieldOptions(decoded);
          return ResponseGetFieldOptions.fromJson(decoded);
        }
        throw Exception("Invalid response from server");
      },
      fallback: readfileFieldOptions,
      apiName: "callWSGetFieldOptions",
    );
  }

  /// Fetches the demandes list from API or returns empty on failure.
  static Future<ResponseGetDemandesList> getDemandes() async {
    Dio dio = Dio()..interceptors.add(dioLoggerInterceptor);
    FormData formData = FormData.fromMap({"user_id": userId});
    return _callApiWithFallback<ResponseGetDemandesList>(
      apiCall: () async {
        _log("getDemandes: calling API with formData: ${formData.fields}");
        final response = await dio.post(
          "$baseUrl/demandes/get_demandes",
          data: formData,
          options: Options(method: "POST", headers: {
            'Content-Type': 'multipart/form-data;charset=UTF-8',
            'Accept': 'application/json',
          }),
        );
        final decoded = _decodeResponseData(response, "getDemandes");
        if (decoded != null) {
          writeToFileDemandeList(decoded);
          return ResponseGetDemandesList.fromJson(decoded);
        }
        return ResponseGetDemandesList(demandes: []);
      },
      fallback: () => readfileDemandesList(),
      apiName: "getDemandes",
    );
  }

  /// Sends an email for the selected demande.
  static Future<bool> callWSSendMail() async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({"demande_id": selectedDemande?.id});
    try {
      _log("callWSSendMail: calling API");
      Response apiRespon = await dio.post(
        "$baseUrl/traitements/send_mail",
        data: formData,
        options: Options(
          method: "POST",
          headers: {
            'Content-Type': 'multipart/form-data;charset=UTF-8',
            'Accept': 'application/json',
          },
        ),
      );
      _log(
          "callWSSendMail: Response ${apiRespon.statusCode}, body: ${apiRespon.data}");
      return (apiRespon.statusCode == 200 && apiRespon.data == "000");
    } catch (e, st) {
      _logError("callWSSendMail: Exception", e, st);
      return false;
    }
  }

  /// Write pannes list to local file
  static void writeToFilePannesList(Map jsonMapContent) {
    _log("writeToFilePannesList");
    try {
      filePannesList.writeAsStringSync(json.encode(jsonMapContent));
    } catch (e, st) {
      _logError("writeToFilePannesList exception", e, st);
    }
  }

  /// Write etats list to local file
  static void writeToFileEtatsList(Map<String, dynamic> jsonMapContent) {
    _log("writeToFileEtatsList");
    try {
      fileEtatsList.writeAsStringSync(json.encode(jsonMapContent));
    } catch (e, st) {
      _logError("writeToFileEtatsList exception", e, st);
    }
  }

  static void writeToFileFieldOptions(List<dynamic> jsonContent) {
    _log("writeToFileFieldOptions");
    try {
      fileFieldOptions.writeAsStringSync(json.encode(jsonContent));
    } catch (e, st) {
      _logError("writeToFileFieldOptions exception", e, st);
    }
  }

  /// Write demandes list to local file
  static void writeToFileDemandeList(Map jsonMapContent) {
    _log("writeToFileDemandeList");
    try {
      fileDemandesList.writeAsStringSync(json.encode(jsonMapContent));
    } catch (e, st) {
      _logError("writeToFileDemandeList exception", e, st);
    }
  }

  /// Reads the traitement list from local file and tries to sync it with API.
  static Future<void> readFileTraitementList() async {
    _log("readFileTraitementList started");
    try {
      String fileContent = fileTraitementList.readAsStringSync();
      if (fileContent.isNotEmpty) {
        _log("readFileTraitementList: file content: $fileContent");
        Map<String, dynamic> demandeListMap = json.decode(fileContent);
        List traitementList = demandeListMap.values.elementAt(0);
        List traitementListResult = [];

        for (var element in traitementList) {
          var isUpdated = await callWsAddMobileFromLocale(jsonDecode(element));
          if (!isUpdated) {
            traitementListResult.add(element);
          }
        }

        Map rsultMap = {"traitementList": traitementListResult};
        fileTraitementList.writeAsStringSync(json.encode(rsultMap));
      } else {
        _log("readFileTraitementList: empty file");
      }
    } catch (e, st) {
      _logError("readFileTraitementList exception", e, st);
    }
  }

  /// Prepares a single image field (apply watermark if needed).
  static Future<void> _prepareImageField(Map<String, dynamic> jsonMapContent,
      String field, String currentDate, String currentAddress) async {
    if (jsonMapContent[field] == null ||
        jsonMapContent[field] == "null" ||
        jsonMapContent[field] == "") return;

    final splitted = jsonMapContent[field].split(";;");
    String imagePath = splitted[0];
    String imageName = splitted[1];

    try {
      if (localWatermark) {
        final fileResult = File(imagePath);
        final image = imagePlugin.decodeImage(fileResult.readAsBytesSync());
        if (image != null) {
          // Add watermark text if needed:
          // For example:
          // imagePlugin.drawString(image, imagePlugin.arial_24, 0, 0, currentDate);
          // imagePlugin.drawString(image, imagePlugin.arial_24, 0, 32, currentAddress);

          Directory dir = await getApplicationDocumentsDirectory();
          File fileResultWithWatermark =
              File("${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png");
          fileResultWithWatermark
              .writeAsBytesSync(imagePlugin.encodePng(image));
          XFile xfileResult = XFile(fileResultWithWatermark.path);

          jsonMapContent[field] = MultipartFile.fromFileSync(
            xfileResult.path,
            filename: xfileResult.name,
          );
        }
      } else {
        jsonMapContent[field] = MultipartFile.fromFileSync(
          imagePath,
          filename: imageName,
        );
      }
    } catch (e, st) {
      _logError("_prepareImageField: Exception for field $field", e, st);
      jsonMapContent[field] = null;
    }
  }

  static Future<bool> callAffectUserAPI(String userId, String demandeId) async {
    _log("callAffectUserAPI started");

    // Prepare the JSON map content
    Map<String, dynamic> jsonMapContent = {
      "User[id]": userId,
      "Demande[id]": demandeId,
      "CurrentUser[id]": Tools.userId,
    };

    // Convert to FormData
    FormData formData = FormData.fromMap(jsonMapContent);

    logFormData(formData);
    try {
      Dio dio = Dio()..interceptors.add(dioLoggerInterceptor);
      _log("callAffectUserAPI: calling API");

      // Call the API
      Response apiResponse = await dio.post(
        "$baseUrl/affectations/affecter_mobile", // Updated endpoint
        data: formData,
        options: Options(
          method: "POST",
          headers: {
            'Content-Type': 'multipart/form-data;charset=UTF-8',
          },
        ),
      );

      _log("callAffectUserAPI: Response ${apiResponse.data}");

      // Check if the response contains "000" (success indicator)
      return (apiResponse.data.contains("000"));
    } catch (e, st) {
      _logError("callAffectUserAPI: Exception", e, st);
      return false;
    }
  }

  /// Calls API to add mobile data from locale.
  static Future<bool> callWsAddMobileFromLocale(
      Map<String, dynamic> jsonMapContent) async {
    _log("callWsAddMobileFromLocale started");
    String currentAddress;
    try {
      currentAddress = await getAddressFromLatLng();
    } catch (e) {
      _logError("callWsAddMobileFromLocale: Failed to get address", e);
      return false;
    }

    String currentDate = jsonMapContent["date"];

    // List of fields that might contain images
    List<String> imageFields = [
      "p_routeur_allume",
      "p_test_signal_via_pm",
      "p_prise_avant",
      "p_prise_apres",
      "p_passage_cable_avant",
      "p_passage_cable_apres",
      "p_cassette_recto",
      "p_cassette_verso",
      "p_speed_test",
      "p_dos_routeur_cin",
      "p_nap_fat_bb_ouvert",
      "p_nap_fat_bb_ferme",
      "p_slimbox_ouvert",
      "p_slimbox_ferme"
    ];

    // Prepare image fields
    for (var field in imageFields) {
      await _prepareImageField(
          jsonMapContent, field, currentDate, currentAddress);
    }

    jsonMapContent.addAll({"isOffline": true});
    FormData formData = FormData.fromMap(jsonMapContent);

    try {
      Dio dio = Dio()..interceptors.add(dioLoggerInterceptor);
      _log("callWsAddMobileFromLocale: calling API");
      Response apiRespon = await dio.post(
        "$baseUrl/traitements/add_mobile",
        data: formData,
        options: Options(
          method: "POST",
          headers: {
            'Content-Type': 'multipart/form-data;charset=UTF-8',
          },
        ),
      );

      _log("callWsAddMobileFromLocale: Response ${apiRespon.data}");
      return (apiRespon.data.contains("000"));
    } catch (e, st) {
      _logError("callWsAddMobileFromLocale: Exception", e, st);
      return false;
    }
  }

  /// Generic file reader with JSON parsing and fallback to empty response.
  static T _readFile<T>(
      File file,
      T Function(dynamic) fromJson, // Accept any JSON structure
      T emptyResponse,
      ) {
    _log("Reading file: ${file.path}");
    try {
      String fileContent = file.readAsStringSync();
      _log("File content: $fileContent");
      if (fileContent.isNotEmpty) {
        dynamic data = json.decode(fileContent);
        return fromJson(data); // Allow `fromJson` to handle both Map and List
      } else {
        _log("File is empty: ${file.path}");
      }
    } catch (e, st) {
      _logError("Exception while reading ${file.path}", e, st);
    }
    return emptyResponse;
  }

  /// Reads etats list from local file.
  static ResponseGetListEtats readfileEtatsList() {
    return _readFile<ResponseGetListEtats>(
      fileEtatsList,
      (data) => ResponseGetListEtats.fromJson(data),
      ResponseGetListEtats(
          etats: []), // Default value if file is empty or fails
    );
  }

  static ResponseGetFieldOptions readfileFieldOptions() {
    return _readFile<ResponseGetFieldOptions>(
      fileFieldOptions,
      (data) => ResponseGetFieldOptions.fromJson(data as List<dynamic>),
      ResponseGetFieldOptions(fieldOptions: []),
    );
  }

  /// Reads demandes list from local file.
  static ResponseGetDemandesList readfileDemandesList() {
    return _readFile<ResponseGetDemandesList>(
      fileDemandesList,
      (data) => ResponseGetDemandesList.fromJson(data),
      ResponseGetDemandesList(demandes: []),
    );
  }

  /// Gets etats list from either API or local cache.
  static Future<ResponseGetListEtats> getEtatsListFromLocalAndInternet() async {
    _log("getEtatsListFromLocalAndInternet started");
    if (await tryConnection()) {
      return callWSGetEtats();
    } else {
      return readfileEtatsList();
    }
  }

  static Future<ResponseGetFieldOptions>
      getFieldOptionsFromLocalAndInternet() async {
    _log("getFieldOptionsFromLocalAndInternet started");
    if (await tryConnection()) {
      return callWSGetFieldOptions();
    } else {
      return readfileFieldOptions();
    }
  }

  static  Future<bool> tryConnection() async {
    developer.log('tryConnection called ', name: 'Tools');
    try {
      // Make a request to a reliable server (e.g., Google) with a timeout of 5 seconds
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(Duration(seconds: 5)); // Set a timeout of 5 seconds

      return response.statusCode == 200; // If the request is successful, there is internet access
    } on TimeoutException {
      developer.log('Internet check timed out', name: 'Tools');
      return false; // No internet access if the request times out
    } catch (e) {
      developer.log('Error checking internet access: $e', name: 'Tools');
      return false; // No internet access if there's an error
    }
  }

  /// Gets demandes list from either API or local cache.
  static Future<ResponseGetDemandesList>
      getListDemandeFromLocalAndINternet() async {
    _log("getListDemandeFromLocalAndINternet started");
    if (await tryConnection()) {
      return getDemandes();
    } else {
      return readfileDemandesList();
    }
  }

  static Future<bool> callWsLogin(Map<String, dynamic> formDateValues) async {
    _log("callWsLogin started");

    formDateValues["registration_id"] = deviceToken;
    formDateValues["fcm_token"] = await getAccessTokenFromServiceAccount();
    _log("Request Data: ${formDateValues.toString()}");

    final formData = FormData.fromMap(formDateValues);
    final dio = Dio();

    try {
      _log("callWsLogin: calling API");
      final response = await dio.post(
        "$baseUrl/users/login_android",
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data;charset=UTF-8',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final result = json.decode(response.data);
        final uid = result["id"]?.toString() ?? "";
        final uname = result["name"]?.toString() ?? "";
        _log("Response Data: $result");

        if (uid.isNotEmpty && uid != "0") {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isOnline', true);
          await prefs.setString('userId', uid);
          await prefs.setString('userName', uname);
          await prefs.setString('role_id', uname);
          await prefs.setString('userEmail', formDateValues["username"] ?? "");
          userId = uid;
          userName = uname;
          roleId = result["role_id"]?.toString() ?? "";
          userEmail = formDateValues["username"] ?? "";

          // Parse and populate the userList
          if (result.containsKey("user_list")) {
            userList = (result["user_list"] as List)
                .map((userJson) => User.fromJson(userJson))
                .toList();
          }
          return true;
        }
      }
    } catch (e, st) {
      _logError("callWsLogin: Exception", e, st);
    }

    return false;
  }

  /// Determines the device's current position.
  static Future<Position> determinePosition() async {
    _log("determinePosition started");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Les services de localisation sont désactivés.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les autorisations de localisation sont refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Les autorisations de localisation sont définitivement refusées.');
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Refreshes the selected demande from API and updates the local cache.
  static Future<bool> refreshSelectedDemande() async {
    _log("refreshSelectedDemande started");
    FormData formData =
        FormData.fromMap({"demande_id": selectedDemande?.id ?? ""});
    try {
      Dio dio = Dio()..interceptors.add(dioLoggerInterceptor);
      Response apiRespon = await dio.post(
        "$baseUrl/demandes/get_demandes_byid",
        data: formData,
        options: Options(
          method: "POST",
          headers: {
            'Content-Type': 'multipart/form-data;charset=UTF-8',
            'Accept': 'application/json',
          },
        ),
      );

      var decoded = _decodeResponseData(apiRespon, "refreshSelectedDemande");
      if (decoded != null) {
        ResponseGetDemandesList demandesList =
            ResponseGetDemandesList.fromJson(decoded);
        selectedDemande = demandesList.demandes?.first;

        int? selectedIndex = demandesListSaved?.demandes
            ?.indexWhere((element) => element.id == selectedDemande?.id);

        if (selectedIndex != null &&
            selectedIndex >= 0 &&
            selectedDemande != null) {
          demandesListSaved?.demandes?[selectedIndex] = selectedDemande!;


          // Notify UI that the demandes list has been updated
          demandeListKey.currentState?.filterListByMap();
        }
        return true;
      }
      return false;
    } catch (e, st) {
      _logError("refreshSelectedDemande: Exception", e, st);
      return false;
    }
  }

  /// Returns an address string based on current location.
  static Future<String> getAddressFromLatLng() async {
    _log("getAddressFromLatLng started");
    Position position = await determinePosition();
    String coordinateString =
        "( latitude = ${position.latitude} longitude = ${position.longitude} )";
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    String fullAddress =
        " ${place.locality}, ${place.postalCode}, ${place.country}";
    return "$coordinateString $fullAddress";
  }

  /// Returns a color corresponding to the demande state.
  static Color getColorByEtatId(String? etatId) {
    if (etatId == null) return Colors.transparent;

    // Define the color mappings
    const errorColor = Color(0xffdc3545); // Red
    const warningColor = Color(0xfff4c22b); // Yellow
    const plannedColor = Color(0xfffd7e14); // Orange
    const inProgressColor = Color(0xff20c997); // Green
    const completedColor = Color(0xff1de9b6); // Teal

    // Use the static const variables for comparison
    switch (etatId) {
      case ANNULATION_CLIENT:
      case CONTACT_ERRONE:
      case DOUBLON:
      case INTERVENTION_BLOQUEE:
      case BLOCAGE_INSTALLATION:
        return errorColor;
      case ATTENTE_RETOUR_CLIENT:
      case CLIENT_INJOIGNABLE:
        return warningColor;
      case PLANIFIEE:
        return plannedColor;
      case ATTENTE_ACTIVATION:
      case INSTALLATION_EN_COURS:
        return inProgressColor;
      case FIN_INSTALLATION:
        return completedColor;
      default:
        return Colors.transparent; // Default color for unknown states
    }
  }

  static Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // `googleAuth.aLiscessToken` and `googleAuth.idToken` can be sent to your backend
      // to verify and create a session. You can also integrate these tokens with
      // Firebase Auth or any other auth system if needed.

      print("User signed in: ${googleUser.displayName}");
      print("User email: ${googleUser.email}");
      print("Access Token: ${googleAuth.accessToken}");
      print("ID Token: ${googleAuth.idToken}");

      // You can store user info or navigate to a new screen after successful sign-in.
    } catch (error) {
      print("Google sign-in failed: $error");
    }
  }

  static Future<String?> getAccessTokenFromServiceAccount() async {
    final jsonStr = await rootBundle.loadString('assets/service-account.json');
    final credentials = jsonDecode(jsonStr);

    final serviceAccountCredentials = auth.ServiceAccountCredentials(
      credentials['client_email'],
      auth.ClientId(credentials['client_id'], null),
      credentials['private_key'],
    );

    final scopes = ['https://www.googleapis.com/auth/cloud-platform'];
    final client =
        await auth.clientViaServiceAccount(serviceAccountCredentials, scopes);
    final token = client.credentials.accessToken.data;
    client.close();

    // log(token);
    print("getAccessTokenFromServiceAccount => Token: $token");
    return token;
  }

  static String getMsgShare(int currentStepNotifier) {
    final demande = Tools.selectedDemande;

    return '''
      REF: ${demande?.numero ?? ""}
      CASE ID: ${demande?.parent ?? ""}
      CLIENT: ${demande?.consommateur ?? ""}
      ADRESSE: ${demande?.adresseComplement1 ?? ""}
      ETAT: ${demande?.etatName ?? ""}
      ''';
  }

  static void logFormData(FormData formData) {
    debugPrint("=== FormData Content ===");

    // Log des champs texte
    for (var field in formData.fields) {
      debugPrint("Text Field - ${field.key}: ${field.value}");
    }

    // Log des fichiers
    for (var file in formData.files) {
      debugPrint("File Field - ${file.key}: ${file.value.filename}, ContentType: ${file.value.contentType}");
    }

    debugPrint("========================");
  }
}

Widget buildConnectivityStatus(ConnectivityStatus state, BuildContext context) {
  if (state == ConnectivityStatus.initial) {
    // Unknown: Display nothing
    return Container();
  }

  if (state == ConnectivityStatus.connected) {
    // Online: Display a green bar
    return Positioned(
      bottom: 0,
      child: Center(
        child: Container(
          color: Colors.green,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.zero,
          height: 6,
        ),
      ),
    );

  } else {
    // Offline: Display a grey bar with a message
    return Positioned(
      bottom: 0,
      child: Center(
        child: Container(
          color: Colors.grey.shade400,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.zero,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Pas d'accès internet", // Message when offline
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
