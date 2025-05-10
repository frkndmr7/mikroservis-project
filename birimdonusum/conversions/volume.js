// Tüm hacim birimlerini litreye göre tanımla (1 birim kaç litre)
const birimler = {
  "ml": 0.001,           // mililitre
  "cl": 0.01,            // santilitre
  "dl": 0.1,             // desilitre
  "l": 1,                // litre
  "m³": 1000,            // metreküp
  "cm³": 0.001,          // santimetreküp
  "mm³": 0.000001,       // milimetreküp
  "gal": 3.78541,        // ABD galonu
  "qt": 0.946353,        // ABD quarti (çeyrek galon)
  "pt": 0.473176,        // ABD pinti
  "fl oz": 0.0295735,    // ABD sıvı ons
  "ukgal": 4.54609,      // İngiliz galonu
  "bbl": 158.987295      // petrol varili
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
  // 1. Önce değeri litreye çevir
  const litreCinsinden = deger * birimler[kaynakBirim];
  // 2. Litreyi hedef birime çevir
  const sonuc = litreCinsinden / birimler[hedefBirim];
  
  return { deger: sonuc };
}

module.exports = {
  birimler,
  donustur
};
