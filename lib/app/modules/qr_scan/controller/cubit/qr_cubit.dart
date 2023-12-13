import 'package:akij_project/app/modules/qr_scan/qr_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

part 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  QrCubit() : super(QrInitial());

  void ScanQrCode(BuildContext _context) async {
    String barcodeScanResult;
    emit(const QrResultLoading());
    try {
      barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      emit(QrResult(qrRes: barcodeScanResult));
      Navigator.pushNamed(_context, MobileScannerScreen.routeName);

      debugPrint('Result : $barcodeScanResult');
    } on PlatformException {
      barcodeScanResult = 'Failed to get Platform version';
      emit(QrResultError(barcodeScanResult));
    }
  }
}
