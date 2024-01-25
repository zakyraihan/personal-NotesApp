// To parse this JSON data, do
//
//     final NotesResult = NotesResultFromJson(jsonString);

import 'dart:convert';

NotesResult NotesResultFromJson(String str) =>
    NotesResult.fromJson(json.decode(str));

String NotesResultToJson(NotesResult data) => json.encode(data.toJson());

class NotesResult {
  String description;

  NotesResult({
    required this.description,
  });

  factory NotesResult.fromJson(Map<String, dynamic> json) => NotesResult(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}
