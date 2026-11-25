import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    this.id,
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    this.description = '',
    this.website = '',
    this.isCurrent = false,
    this.degreeDisplay = '',
    this.createdAt,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  @JsonKey(includeToJson: false)
  final String? id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String description;
  final String website;
  final bool isCurrent;
  @JsonKey(includeToJson: false)
  final String degreeDisplay;
  @JsonKey(includeToJson: false)
  final DateTime? createdAt;
  @JsonKey(includeToJson: false)
  final int starCount;
  @JsonKey(includeToJson: false)
  final bool isStarred;
  @JsonKey(includeToJson: false)
  final String starredByNames;

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
