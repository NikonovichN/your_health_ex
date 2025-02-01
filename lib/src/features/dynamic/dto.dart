import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class DynamicDTO {
  final List<LaboratoryDTO> dynamics;
  final List<AlertDTO> alerts;

  const DynamicDTO({
    required this.dynamics,
    required this.alerts,
  });

  factory DynamicDTO.fromJson(Map<String, dynamic> json) => _$DynamicDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DynamicDTOToJson(this);
}

@JsonSerializable()
class LaboratoryDTO {
  @JsonKey(name: 'lab')
  final String title;
  final String date;
  final double value;

  const LaboratoryDTO({
    required this.date,
    required this.title,
    required this.value,
  });

  factory LaboratoryDTO.fromJson(Map<String, dynamic> json) => _$LaboratoryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LaboratoryDTOToJson(this);
}

@JsonSerializable()
class AlertDTO {
  final String message;
  final bool resubmitLink;

  const AlertDTO({
    required this.message,
    required this.resubmitLink,
  });

  factory AlertDTO.fromJson(Map<String, dynamic> json) => _$AlertDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AlertDTOToJson(this);
}
