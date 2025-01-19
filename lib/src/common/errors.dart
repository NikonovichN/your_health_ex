import 'package:equatable/equatable.dart';

class RepositoryError extends Equatable implements Error {
  final String message;

  const RepositoryError({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  StackTrace? get stackTrace => StackTrace.fromString(message);
}
