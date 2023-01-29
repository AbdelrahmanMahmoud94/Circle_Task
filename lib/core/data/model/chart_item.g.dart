// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartItem _$ChartItemFromJson(Map<String, dynamic> json) => ChartItem(
      open: (json['open'] as num?)?.toDouble(),
      high: (json['High'] as num?)?.toDouble(),
      low: (json['Low'] as num?)?.toDouble(),
      close: (json['Close'] as num?)?.toDouble(),
      adjClose: (json['Adj Close'] as num?)?.toDouble(),
      volume: json['Volume'] as int?,
      date:
          json['Date'] == null ? null : DateTime.parse(json['Date'] as String),
    );

Map<String, dynamic> _$ChartItemToJson(ChartItem instance) => <String, dynamic>{
      'open': instance.open,
      'High': instance.high,
      'Low': instance.low,
      'Close': instance.close,
      'Adj Close': instance.adjClose,
      'Volume': instance.volume,
      'Date': instance.date?.toIso8601String(),
    };
