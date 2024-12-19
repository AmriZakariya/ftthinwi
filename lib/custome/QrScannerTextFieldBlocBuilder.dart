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
        return Container(
          child: Row(
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
              ElevatedButton(
                onPressed: () async {
                  // Open the scanner page
                  final scannedValue = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScannerPage(),
                    ),
                  );

                  if (scannedValue != null) {
                    // Format the value if necessary
                    if (widget.qrCodeTextFieldBloc.name == "adresse_mac") {
                      String formattedMAC = "";
                      for (int i = 0; i < scannedValue.length; i++) {
                        formattedMAC += scannedValue[i];
                        if ((i % 2 != 0) && (i < scannedValue.length - 1)) {
                          formattedMAC += "-";
                        }
                      }
                      widget.qrCodeTextFieldBloc.updateValue(formattedMAC);
                    } else {
                      widget.qrCodeTextFieldBloc.updateValue(scannedValue);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                ),
                child: const Icon(Icons.qr_code_scanner),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Code"),
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? scannedValue = barcodes.first.rawValue;
            if (scannedValue != null) {
              Navigator.of(context).pop(scannedValue); // Return scanned value
            }
          }
        },
      ),
    );
  }
}
