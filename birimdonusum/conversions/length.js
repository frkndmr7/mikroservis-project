// Tüm uzunluk birimlerini metreye göre tanımla (1 birim kaç metre)
const birimler = {
  "mm": 0.001,
  "cm": 0.01,
  "m": 1,
  "km": 1000,
  "inç": 0.0254,
  "ft": 0.3048,
  "yd": 0.9144,
  "mil": 1609.344
};

// Dönüşüm fonksiyonu
function donustur(deger, kaynakBirim, hedefBirim) {
  // Birim kontrolü
  if (!birimler[kaynakBirim]) {
    return { hata: `Geçersiz kaynak birim: ${kaynakBirim}` };
  }
  if (!birimler[hedefBirim]) {
    return { hata: `Geçersiz hedef birim: ${hedefBirim}` };
  }
  
  // Dönüşüm hesaplaması
  // 1. Önce değeri metreye çevir
  const metreCinsinden = deger * birimler[kaynakBirim];
  // 2. Metreyi hedef birime çevir
  const sonuc = metreCinsinden / birimler[hedefBirim];
  
  return { deger: sonuc };
}

module.exports = {
  birimler,
  donustur
};
