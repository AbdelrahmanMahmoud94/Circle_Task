import 'package:equatable/equatable.dart';

abstract class Model extends Equatable {}

abstract class BaseModel<T> extends Model {
  T fromJson(Map<String, dynamic> json);
}
