class UretimModel {
  int? id;
  String referansAdi;
  String vulkanizeKodu;
  String ebosKodu;
  int macaSayisi;
  int uretimAdedi;
  String kayitZamani;

  UretimModel({
    this.id,
    required this.referansAdi,
    required this.vulkanizeKodu,
    required this.ebosKodu,
    required this.macaSayisi,
    required this.uretimAdedi,
    required this.kayitZamani,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referansAdi': referansAdi,
      'vulkanizeKodu': vulkanizeKodu,
      'ebosKodu': ebosKodu,
      'macaSayisi': macaSayisi,
      'uretimAdedi': uretimAdedi,
      'kayitZamani': kayitZamani,
    };
  }

  factory UretimModel.fromMap(Map<String, dynamic> map) {
    return UretimModel(
      id: map['id'],
      referansAdi: map['referansAdi'],
      vulkanizeKodu: map['vulkanizeKodu'],
      ebosKodu: map['ebosKodu'],
      macaSayisi: map['macaSayisi'],
      uretimAdedi: map['uretimAdedi'],
      kayitZamani: map['kayitZamani'],
    );
  }
}
