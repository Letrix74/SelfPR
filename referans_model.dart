class ReferansModel {
  int? id;
  String referansAdi;
  String vulkanizeKodu;
  String ebosKodu;
  int? macaSayisi;
  int? uretimAdedi;

  ReferansModel({
    this.id,
    required this.referansAdi,
    required this.vulkanizeKodu,
    required this.ebosKodu,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referansAdi': referansAdi,
      'vulkanizeKodu': vulkanizeKodu,
      'ebosKodu': ebosKodu,
    };
  }

  factory ReferansModel.fromMap(Map<String, dynamic> map) {
    return ReferansModel(
      id: map['id'],
      referansAdi: map['referansAdi'],
      vulkanizeKodu: map['vulkanizeKodu'],
      ebosKodu: map['ebosKodu'],
    );
  }
}
