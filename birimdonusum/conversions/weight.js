// Tüm ağırlık birimlerini kilograma göre tanımla (1 birim kaç kilogram)
const birimler = {
  "mg": 0.000001,
  "g": 0.001,
  "kg": 1,
  "ton": 1000,
  "lb": 0.45359237,     // pound
  "oz": 0.0283495231,   // ons
  "gr": 0.0000647989,   // grain
  "ct": 0.0002,         // karat
  "st": 6.35029318      // stone (İngiliz ağırlık birimi)
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
  // 1. Önce değeri kilograma çevir
  const kgCinsinden = deger * birimler[kaynakBirim];
  // 2. Kilogramı hedef birime çevir
  const sonuc = kgCinsinden / birimler[hedefBirim];
  
  return { deger: sonuc };
}

module.exports = {
  birimler,
  donustur
};
