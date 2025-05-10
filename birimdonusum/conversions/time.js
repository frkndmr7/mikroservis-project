// Tüm zaman birimlerini saniyeye göre tanımla (1 birim kaç saniye)
const birimler = {
  "ms": 0.001,          // milisaniye
  "s": 1,               // saniye
  "dk": 60,             // dakika
  "sa": 3600,           // saat
  "gün": 86400,         // gün
  "hafta": 604800,      // hafta
  "ay": 2592000,        // ay (30 gün)
  "yıl": 31536000,      // yıl (365 gün)
  "yüzyıl": 3153600000  // yüzyıl (100 yıl)
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
  // 1. Önce değeri saniyeye çevir
  const saniyeCinsinden = deger * birimler[kaynakBirim];
  // 2. Saniyeyi hedef birime çevir
  const sonuc = saniyeCinsinden / birimler[hedefBirim];
  
  return { deger: sonuc };
}

// Özel dönüşümler için yardımcı fonksiyonlar (ileride eklenebilir)
// Örneğin: Belirli bir tarihe gün/ay/yıl ekleme, tarih formatları arası dönüşüm, vb.

module.exports = {
  birimler,
  donustur
};
