import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../common/errors.dart';
import 'repository.dart';
import 'dto.dart';

class Laboratory extends Equatable {
  final String title;
  final DateTime date;
  final double value;

  const Laboratory({required this.title, required this.date, required this.value});

  @override
  List<Object?> get props => [title, date, value];
}

class Alert extends Equatable {
  final String message;
  final bool resubmitLink;

  const Alert({required this.message, required this.resubmitLink});

  @override
  List<Object?> get props => [message, resubmitLink];
}

class DynamicScreenData extends Equatable {
  final List<Laboratory> laboratories;
  final List<Alert> alerts;

  const DynamicScreenData({required this.laboratories, required this.alerts});

  @override
  List<Object?> get props => [laboratories, alerts];
}

class DynamicScreenState extends Equatable {
  final bool isLoading;
  final DynamicScreenData? screenData;
  final RepositoryError? error;

  const DynamicScreenState({required this.isLoading, this.screenData, this.error});

  @override
  List<Object?> get props => [isLoading, screenData, error];

  DynamicScreenState copyWith({
    required bool isLoading,
    DynamicScreenData? screenData,
    RepositoryError? error,
  }) {
    return DynamicScreenState(
      isLoading: isLoading,
      screenData: screenData ?? this.screenData,
      error: error ?? this.error,
    );
  }
}

abstract class DynamicScreenController {
  Future<void> loadData();
  Stream<DynamicScreenState> get stream;
  DynamicScreenState get state;
}

class DynamicScreenControllerImpl implements DynamicScreenController {
  final StreamController<DynamicScreenState> _controller =
      StreamController<DynamicScreenState>.broadcast();

  DynamicScreenState _state = const DynamicScreenState(isLoading: false);

  final DynamicRepository _repository;

  DynamicScreenControllerImpl({
    required DynamicRepository repository,
  }) : _repository = repository;

  @override
  Stream<DynamicScreenState> get stream => _controller.stream;

  @override
  DynamicScreenState get state => _state;

  void emit(DynamicScreenState newState) {
    _state = newState;
    _controller.add(newState);
  }

  @override
  Future<void> loadData() async {
    if (state.isLoading) {
      return;
    }

    emit(_state.copyWith(isLoading: true, screenData: null, error: null));

    try {
      final data = await _repository.loadData();

      emit(
        _state.copyWith(
          isLoading: false,
          screenData: data.toScreenData(),
          error: null,
        ),
      );
    } catch (e) {
      emit(_state.copyWith(
        isLoading: false,
        screenData: null,
        error: RepositoryError(
          message: e.toString(),
        ),
      ));
    }
  }
}

extension on DynamicDTO {
  DynamicScreenData toScreenData() => DynamicScreenData(
        alerts: alerts.map((e) => e.toScreenData()).toList(),
        laboratories: dynamics.map((e) => e.toScreenData()).toList(),
      );
}

extension on LaboratoryDTO {
  int getPartDateByIndex(int indx) => int.tryParse(date.split('-')[indx]) ?? 0;

  Laboratory toScreenData() => Laboratory(
        title: title,
        date: DateTime(
          getPartDateByIndex(0),
          getPartDateByIndex(1),
          getPartDateByIndex(2),
        ),
        value: value,
      );
}

extension on AlertDTO {
  Alert toScreenData() => Alert(message: message, resubmitLink: resubmitLink);
}
