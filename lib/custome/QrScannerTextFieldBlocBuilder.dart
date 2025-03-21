import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerTextFieldBlocBuilder extends StatefulWidget {
  final TextFieldBloc<dynamic> qrCodeTextFieldBloc;
  final FormBloc formBloc;
  final Widget iconField;
  final String labelText;

  QrScannerTextFieldBlocBuilder({
    Key? key,
    required this.qrCodeTextFieldBloc,
    required this.formBloc,
    required this.iconField,
    required this.labelText,
  }) : super(key: key);

  @override
  State<QrScannerTextFieldBlocBuilder> createState() =>
      _QrScannerTextFieldBlocBuilderState();
}

class _QrScannerTextFieldBlocBuilderState
    extends State<QrScannerTextFieldBlocBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
      bloc: widget.qrCodeTextFieldBloc,
      builder: (context, state) {
        return Row(
          children: [
            Flexible(
              child: TextFieldBlocBuilder(
                textFieldBloc: widget.qrCodeTextFieldBloc,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  prefixIcon: widget.iconField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 1),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.formBloc.state
                  .fieldBlocs()
                  ?.containsKey(widget.qrCodeTextFieldBloc.name) ??
                  true,
              child: ElevatedButton(
                onPressed: () async {
                  final scannedValue = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ScannerPage();
                      },
                    ),
                  );

                  if (scannedValue != null && scannedValue is String) {
                    String formattedValue = scannedValue;

                    if (widget.qrCodeTextFieldBloc.name == "adresse_mac") {
                      formattedValue = _formatMacAddress(scannedValue);
                    }

                    setState(() {
                      widget.qrCodeTextFieldBloc.updateValue(formattedValue);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  iconSize: 25,
                ),
                child: const Icon(Icons.qr_code),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Formats MAC Address
  String _formatMacAddress(String raw) {
    String formattedMAC = "";
    for (int i = 0; i < raw.length; i++) {
      formattedMAC += raw[i];
      if ((i % 2 != 0) && (i < raw.length - 1)) {
        formattedMAC += "-";
      }
    }
    return formattedMAC;
  }
}

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  bool _isScanning = true; // Prevent multiple scans

  @override
  void dispose() {
    controller.stop(); // Stop the camera before disposing
    controller.dispose(); // Release camera resources
    super.dispose();
  }

  BoxFit boxFit = BoxFit.contain;
  final double containerWidth = 150;
  final double containerHeight = 80;

  @override
  void initState() {
    super.initState();
    controller.start(); // Ensure the camera starts
  }

  @override
  Widget build(BuildContext context) {
    final scanWindowWidth = containerWidth * 0.8;
    final scanWindowHeight = containerHeight * 0.2;

    final scanWindow = Rect.fromLTWH(
      (containerWidth - scanWindowWidth) / 2,
      (containerHeight - scanWindowHeight) / 3,
      scanWindowWidth,
      scanWindowHeight,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scanner un QR Code"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover,
            onDetect: (BarcodeCapture capture) async {
              if (!_isScanning) return; // Prevent multiple triggers

              _isScanning = false; // Block further detections

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? scannedValue = barcodes.first.rawValue;
                debugPrint("Scanned QR Code: $scannedValue"); // Debugging

                if (scannedValue != null && context.mounted) {
                  await controller.stop();
                  Navigator.of(context).pop(scannedValue);
                }
              }
            },
          ),

          // Smaller Scan Area
          Center(
            child: Stack(
              children: [
                Container(
                  width: 150, // Smaller scan area
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Positioned(
                  bottom: 30, // Move it below the scan area
                  left: 0,
                  right: 0,
                  child: Text(
                    "Alignez le code avec le cadre",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7), // Subtle visibility
                      fontSize: 12, // Smaller text
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              ],
            ),
          ),

          // Animated Scan Line (Adjusted)
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 75,
            left: MediaQuery.of(context).size.width / 2 - 75,
            child: SizedBox(
              width: 150,
              height: 150,
              child: AnimatedAlign(
                alignment: Alignment.bottomCenter,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                child: Container(
                  width: 150,
                  height: 2,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
