part of 'geo_punch_list_cubit.dart';

sealed class GeoPunchListState extends Equatable {
  const GeoPunchListState();

  @override
  List<Object> get props => [];
}

final class GeoPunchListInitial extends GeoPunchListState {}

final class GeoPunchListFetching extends GeoPunchListState {}

final class GeoPunchListFetched extends GeoPunchListState {
  final List<GeoPunch> punchList;
  const GeoPunchListFetched(this.punchList);

  @override
  List<Object> get props => [punchList];
}

final class GeoPunchListFetchError extends GeoPunchListState {
  final String errorMessage;
  const GeoPunchListFetchError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
