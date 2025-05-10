// Sıcaklık dönüşümleri için özel formüller gerekir
// Doğrudan katsayı çarpımı yerine özel hesaplamalar yapılacak
const birimler = {
  "°C": "celsius",
  "°F": "fahrenheit",
  "K": "kelvin",
  "°R": "rankine"  // Rankine ölçeği (mutlak sıcaklık)
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
  
  // Sıcaklık dönüşümleri için özel hesaplamalar
  const kaynakTip = birimler[kaynakBirim];
  const hedefTip = birimler[hedefBirim];
  
  // Önce değeri Celsius'a çevir
  let celsiusDeger;
  switch(kaynakTip) {
    case "celsius":
      celsiusDeger = deger;
      break;
    case "fahrenheit":
      celsiusDeger = (deger - 32) * (5/9);
      break;
    case "kelvin":
      celsiusDeger = deger - 273.15;
      break;
    case "rankine":
      celsiusDeger = (deger - 491.67) * (5/9);
      break;
  }
  
  // Celsius'tan hedef birime çevir
  let sonuc;
  switch(hedefTip) {
    case "celsius":
      sonuc = celsiusDeger;
      break;
    case "fahrenheit":
      sonuc = celsiusDeger * (9/5) + 32;
      break;
    case "kelvin":
      sonuc = celsiusDeger + 273.15;
      break;
    case "rankine":
      sonuc = (celsiusDeger + 273.15) * (9/5);
      break;
  }
  
  return { deger: sonuc };
}

module.exports = {
  birimler,
  donustur
};
