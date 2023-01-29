import 'package:circle_task/core/data/model/model.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'chart_item.g.dart';

@JsonSerializable()
class ChartItem extends BaseModel<ChartItem>{
  ChartItem({
    this.open,
    this.high,
    this.low,
    this.close,
    this.adjClose,
    this.volume,
    this.date,
  });

  final double? open;
  @JsonKey(name: "High")
  final double? high;
  @JsonKey(name: "Low")
  final double? low;
  @JsonKey(name: "Close")
  final double? close;
  @JsonKey(name: "Adj Close")
  final double? adjClose;
  @JsonKey(name: "Volume")
  final int? volume;
  @JsonKey(name: "Date")
  final DateTime? date;

  @override
  List<Object?> get props => <Object?>[
        open,
        high,
        low,
        close,
        adjClose,
        volume,
        date,
      ];

  factory ChartItem.fromJson(Map<String, dynamic> json) => _$ChartItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChartItemToJson(this);
  
  @override
  fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
}
