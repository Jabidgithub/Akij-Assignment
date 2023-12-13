part of 'geo_punch_cubit.dart';

sealed class GeoPunchState extends Equatable {
  const GeoPunchState();

  @override
  List<Object> get props => [];
}

final class GeoPunchInitial extends GeoPunchState {
  @override
  List<Object> get props => [];
}

final class GeoPunchLoading extends GeoPunchState {
  @override
  List<Object> get props => [];
}

final class GeoPunchDone extends GeoPunchState {
  @override
  List<Object> get props => [];
}

final class GeoPunchError extends GeoPunchState {
  final String errorMessage;

  const GeoPunchError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
