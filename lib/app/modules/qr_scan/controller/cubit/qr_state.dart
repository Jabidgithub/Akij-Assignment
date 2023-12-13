part of 'qr_cubit.dart';

sealed class QrState extends Equatable {
  const QrState();

  @override
  List<Object> get props => [];
}

final class QrInitial extends QrState {}

final class QrResult extends QrState {
  final String qrRes;
  const QrResult({required this.qrRes});

  @override
  List<Object> get props => [qrRes];
}

final class QrResultLoading extends QrState {
  const QrResultLoading();

  @override
  List<Object> get props => [];
}

final class QrResultError extends QrState {
  final String errorMessage;
  const QrResultError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
