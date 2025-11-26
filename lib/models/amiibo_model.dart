import 'package:hive/hive.dart';

part 'amiibo_model.g.dart';

@HiveType(typeId: 0)
class AmiiboModel extends HiveObject {
  @HiveField(0)
  String amiiboSeries;

  @HiveField(1)
  String character;

  @HiveField(2)
  String gameSeries;

  @HiveField(3)
  String head;

  @HiveField(4)
  String image;

  @HiveField(5)
  String name;

  @HiveField(6)
  AmiiboRelease release;

  @HiveField(7)
  String tail;

  @HiveField(8)
  String type;

  AmiiboModel({
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.head,
    required this.image,
    required this.name,
    required this.release,
    required this.tail,
    required this.type,
  });

  // Factory constructor untuk parsing dari JSON
  factory AmiiboModel.fromJson(Map<String, dynamic> json) {
    return AmiiboModel(
      amiiboSeries: json['amiiboSeries'] ?? '',
      character: json['character'] ?? '',
      gameSeries: json['gameSeries'] ?? '',
      head: json['head'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      release: AmiiboRelease.fromJson(json['release'] ?? {}),
      tail: json['tail'] ?? '',
      type: json['type'] ?? '',
    );
  }

  // Method untuk convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'amiiboSeries': amiiboSeries,
      'character': character,
      'gameSeries': gameSeries,
      'head': head,
      'image': image,
      'name': name,
      'release': release.toJson(),
      'tail': tail,
      'type': type,
    };
  }
}

@HiveType(typeId: 1)
class AmiiboRelease extends HiveObject {
  @HiveField(0)
  String? au;

  @HiveField(1)
  String? eu;

  @HiveField(2)
  String? jp;

  @HiveField(3)
  String? na;

  AmiiboRelease({this.au, this.eu, this.jp, this.na});

  // Factory constructor untuk parsing dari JSON
  factory AmiiboRelease.fromJson(Map<String, dynamic> json) {
    return AmiiboRelease(
      au: json['au'],
      eu: json['eu'],
      jp: json['jp'],
      na: json['na'],
    );
  }

  // Method untuk convert ke JSON
  Map<String, dynamic> toJson() {
    return {'au': au, 'eu': eu, 'jp': jp, 'na': na};
  }
}
