import 'package:akij_project/app/modules/google_map/geo_punch_list/model/geo_punch_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'geo_punch_list_state.dart';

class GeoPunchListCubit extends Cubit<GeoPunchListState> {
  GeoPunchListCubit() : super(GeoPunchListInitial());

  Future<void> fetchGeoPunchList(String userId) async {
    final apiUrl = "https://www.akijpipes.com/api/lat-long/399";

    emit(GeoPunchListFetching());

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        emit(GeoPunchListFetched(
            data.map((json) => GeoPunch.fromJson(json)).toList()));
        // return data.map((json) => GeoPunch.fromJson(json)).toList();
      } else {
        emit(GeoPunchListFetchError("Server Error"));
        throw Exception(
            "Failed to fetch geo punch list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      emit(GeoPunchListFetchError("Error $e"));
      throw Exception("Error fetching geo punch list: $e");
    }
  }
}
