import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

part 'geo_punch_state.dart';

class GeoPunchCubit extends Cubit<GeoPunchState> {
  GeoPunchCubit() : super(GeoPunchInitial());

  Future<void> hitGeoPunch(LatLng latLng) async {
    emit(GeoPunchLoading());

    final apiUrl = "https://www.akijpipes.com/api/lat-long";
    final payload = {
      "user_id": 399,
      "lat": latLng.latitude,
      "long": latLng.longitude,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Geo punch submitted successfully");
        emit(GeoPunchDone());
      } else {
        print(
            "Failed to submit Geo punch. Status code: ${response.statusCode}");
        emit(GeoPunchError("Server Error"));
      }
    } catch (e) {
      print("Error submitting Geo punch: $e");
      emit(GeoPunchError("Error inb $e"));
    }
  }
}
