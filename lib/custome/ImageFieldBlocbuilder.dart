import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telcabo/Tools.dart';

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class ImageFieldBlocBuilder extends StatefulWidget {
  final InputFieldBloc<XFile?, Object> fileFieldBloc;
  final FormBloc formBloc;
  final Widget iconField;
  final String labelText;

  ImageFieldBlocBuilder({
    Key? key,
    required this.fileFieldBloc,
    required this.formBloc,
    required this.iconField,
    required this.labelText,
  })  : assert(fileFieldBloc != null),
        assert(formBloc != null),
        super(key: key);

  @override
  State<ImageFieldBlocBuilder> createState() => _ImageFieldBlocBuilderState();
}

class _ImageFieldBlocBuilderState extends State<ImageFieldBlocBuilder> {
  final ImagePicker _picker = ImagePicker();
  String imageSrc = "camera";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputFieldBloc<XFile?, Object>,
        InputFieldBlocState<XFile?, Object>>(
      bloc: widget.fileFieldBloc,
      builder: (context, fieldBlocState) {
        return BlocBuilder<FormBloc, FormBlocState>(
          bloc: widget.formBloc,
          builder: (context, formBlocState) {
            return Visibility(
              visible: widget.formBloc.state
                  .fieldBlocs()
                  ?.containsKey(widget.fileFieldBloc.name) ??
                  true,
              child: Column(
                children: [
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : GestureDetector(
                    onTap: formBlocState.canSubmit
                        ? () async {
                      await _showDialog();
                      if (imageSrc != "none") {
                        setState(() => isLoading = true);
                        try {
                          final imageResult = await _pickImage();
                          if (imageResult != null) {
                            // final compressedImage =
                            //     await _compressImage(imageResult);
                            widget.fileFieldBloc.updateValue(
                                XFile(imageResult.path));
                          }
                        } finally {
                          setState(() => isLoading = false);
                        }
                      }
                    }
                        : null,
                    child: _buildImageDisplay(fieldBlocState),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  imageSrc = "camera";
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Caméra'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  imageSrc = "gallery";
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.image_outlined),
                label: const Text('Galerie'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                imageSrc = "none";
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel),
              label: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }


  Future<XFile?> _pickImage() async {
    XFile? pickedFile = await _picker.pickImage(
      source: imageSrc == "camera" ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50, // Adjust as needed
    );

    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);

    // Correct the rotation
    XFile? fixedImageFile = await _fixImageRotation(imageFile);

    return fixedImageFile;
  }

  Future<XFile?> _fixImageRotation(File imageFile) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.path, 'fixed_${path.basename(imageFile.path)}');

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      targetPath,
      quality: 90, // Adjust quality if needed
      autoCorrectionAngle: true, // Corrects rotation automatically
    ); // Explicitly cast to File?

    return compressedFile; // Return original file if compression fails
  }

  Widget _buildImageDisplay(
      InputFieldBlocState<XFile?, Object> fieldBlocState) {
    return Column(
      children: [
        Center(child: Text(widget.labelText, textAlign: TextAlign.center)),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: fieldBlocState.value != null
                    ? Image.file(
                  File(fieldBlocState.value!.path),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                )
                    : _buildPlaceholder(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (fieldBlocState.canShowError) _buildErrorText(),
      ],
    );
  }


  Widget _buildPlaceholder() {
    return CachedNetworkImage(
      imageUrl: getImagePickerExistImageUrl(),
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Center(
        child: Icon(Icons.image_not_supported_outlined, size: 40),
      ),
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Ce champ est obligatoire",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  String getImagePickerExistImageUrl() {
    String imageUrl = "${Tools.baseUrl}/img/demandes/";

    final imageMappings = {
      "p_routeur_allume": Tools.selectedDemande?.pRouteurAllume ?? "",
      "p_test_signal_via_pm": Tools.selectedDemande?.pTestSignalViaPm ?? "",
      "p_prise_avant": Tools.selectedDemande?.pPriseAvant ?? "",
      "p_prise_apres": Tools.selectedDemande?.pPriseApres ?? "",
      "p_passage_cable_avant": Tools.selectedDemande?.pPassageCableAvant ?? "",
      "p_passage_cable_apres": Tools.selectedDemande?.pPassageCableApres ?? "",
      "p_cassette_recto": Tools.selectedDemande?.pCassetteRecto ?? "",
      "p_cassette_verso": Tools.selectedDemande?.pCassetteVerso ?? "",
      "p_speed_test": Tools.selectedDemande?.pSpeedTest ?? "",
      "p_dos_routeur_cin": Tools.selectedDemande?.pDosRouteurCin ?? "",
      "p_nap_fat_bb_ouvert": Tools.selectedDemande?.pNapFatBbOuvert ?? "",
      "p_nap_fat_bb_ferme": Tools.selectedDemande?.pNapFatBbFerme ?? "",
      "p_slimbox_ouvert": Tools.selectedDemande?.pSlimboxOuvert ?? "",
      "p_slimbox_ferme": Tools.selectedDemande?.pSlimboxFerme ?? "",
      "p_trace_avant_1": Tools.selectedDemande?.pTraceAvant1 ?? "",
      "p_trace_avant_2": Tools.selectedDemande?.pTraceAvant2 ?? "",
      "p_trace_avant_3": Tools.selectedDemande?.pTraceAvant3 ?? "",
      "p_trace_avant_4": Tools.selectedDemande?.pTraceAvant4 ?? "",
      "p_trace_apres_1": Tools.selectedDemande?.pTraceApres1 ?? "",
      "p_trace_apres_2": Tools.selectedDemande?.pTraceApres2 ?? "",
      "p_trace_apres_3": Tools.selectedDemande?.pTraceApres3 ?? "",
      "p_trace_apres_4": Tools.selectedDemande?.pTraceApres4 ?? "",
      "p_position_plan_1": Tools.selectedDemande?.pPositionPlan1 ?? "",
      "p_position_plan_2": Tools.selectedDemande?.pPositionPlan2 ?? "",
    };

    // Append the corresponding value based on the fileFieldBloc name
    imageUrl += imageMappings[widget.fileFieldBloc.name] ?? "";

    return imageUrl;
  }
}