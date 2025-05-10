// Tüm alan birimlerini metrekareye göre tanımla (1 birim kaç metrekare)
const birimler = {
  "mm²": 0.000001,        // milimetrekare
  "cm²": 0.0001,          // santimetrekare
  "dm²": 0.01,            // desimetrekare
  "m²": 1,                // metrekare
  "a": 100,               // ar
  "ha": 10000,            // hektar
  "km²": 1000000,         // kilometrekare
  "in²": 0.00064516,      // inçkare
  "ft²": 0.09290304,      // fotkare
  "yd²": 0.83612736,      // yardakare
  "ac": 4046.8564224,     // akre
  "mi²": 2589988.110336   // milkare
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
  // 1. Önce değeri metrekareye çevir
  const metrekareCinsinden = deger * birimler[kaynakBirim];
  // 2. Metrekareyi hedef birime çevir
  const sonuc = metrekareCinsinden / birimler[hedefBirim];
  
  return { deger: sonuc };
}

module.exports = {
  birimler,
  donustur
};
