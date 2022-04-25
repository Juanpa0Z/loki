
import 'dart:convert';
import 'dart:typed_data';

class Sound {
  int? id;
  String name;
  Uint8List media;
  Uint8List image;
  Sound({
    this.id,
    required this.name,
    required this.media,
    required this.image,
  });

  Sound copyWith({
    int? id,
    String? name,
    Uint8List? media,
    Uint8List? image,
  }) {
    return Sound(
      id: id ?? this.id,
      name: name ?? this.name,
      media: media ?? this.media,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    result.addAll({'name': name});
    result.addAll({'media': media});
    result.addAll({'image': image});
  
    return result;
  }

  factory Sound.fromMap(Map<String, dynamic> map) {
    return Sound(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      media: map['media'],
      image:map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Sound.fromJson(String source) => Sound.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Sound(id: $id, name: $name, media: $media, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Sound &&
      other.id == id &&
      other.name == name &&
      other.media == media &&
      other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      media.hashCode ^
      image.hashCode;
  }
}
