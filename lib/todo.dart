import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  // final String id;
  // final String title;
  // final String description;
  // final String limit;
  // final String createdAt;

  const factory Todo({
    required String id,
    required String title,
    required String description,
    required String limit,
    required String createdAt,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
