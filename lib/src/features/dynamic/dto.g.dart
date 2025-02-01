// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DynamicDTO _$DynamicDTOFromJson(Map<String, dynamic> json) => DynamicDTO(
      dynamics: (json['dynamics'] as List<dynamic>)
          .map((e) => LaboratoryDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => AlertDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DynamicDTOToJson(DynamicDTO instance) =>
    <String, dynamic>{
      'dynamics': instance.dynamics,
      'alerts': instance.alerts,
    };

LaboratoryDTO _$LaboratoryDTOFromJson(Map<String, dynamic> json) =>
    LaboratoryDTO(
      date: json['date'] as String,
      title: json['lab'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$LaboratoryDTOToJson(LaboratoryDTO instance) =>
    <String, dynamic>{
      'lab': instance.title,
      'date': instance.date,
      'value': instance.value,
    };

AlertDTO _$AlertDTOFromJson(Map<String, dynamic> json) => AlertDTO(
      message: json['message'] as String,
      resubmitLink: json['resubmitLink'] as bool,
    );

Map<String, dynamic> _$AlertDTOToJson(AlertDTO instance) => <String, dynamic>{
      'message': instance.message,
      'resubmitLink': instance.resubmitLink,
    };
