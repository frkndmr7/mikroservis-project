const express = require('express');
const cors = require('cors');
const app = express();

// Dönüşüm modüllerini import et
const length = require('./conversions/length');
const weight = require('./conversions/weight');
const volume = require('./conversions/volume');
const temperature = require('./conversions/temperature');
const area = require('./conversions/area');
const time = require('./conversions/time');

// JSON ve CORS middleware'leri
app.use(express.json());
app.use(cors());

// Tüm desteklenen kategorileri listele
app.get('/categories', (req, res) => {
  res.json({
    kategoriler: [
      'uzunluk',
      'agirlik',
      'hacim',
      'sicaklik',
      'alan',
      'zaman'
    ]
  });
});

// Belirli bir kategorideki birimleri listele
app.get('/units/:category', (req, res) => {
  const category = req.params.category;
  
  let units = [];
  switch(category) {
    case 'uzunluk':
      units = Object.keys(length.birimler);
      break;
    case 'agirlik':
      units = Object.keys(weight.birimler);
      break;
    case 'hacim':
      units = Object.keys(volume.birimler);
      break;
    case 'sicaklik':
      units = Object.keys(temperature.birimler);
      break;
    case 'alan':
      units = Object.keys(area.birimler);
      break;
    case 'zaman':
      units = Object.keys(time.birimler);
      break;
    default:
      return res.status(400).json({ hata: "Geçersiz kategori" });
  }
  
  res.json({ birimler: units });
});

// Genel dönüşüm endpoint'i
app.post('/convert', (req, res) => {
  const { deger, kaynakBirim, hedefBirim, kategori } = req.body;
  
  // Parametre kontrolü
  if (deger === undefined || !kaynakBirim || !hedefBirim || !kategori) {
    return res.status(400).json({ 
      hata: "Eksik parametreler. 'deger', 'kaynakBirim', 'hedefBirim' ve 'kategori' gerekli." 
    });
  }
  
  let result;
  switch(kategori) {
    case 'uzunluk':
      result = length.donustur(deger, kaynakBirim, hedefBirim);
      break;
    case 'agirlik':
      result = weight.donustur(deger, kaynakBirim, hedefBirim);
      break;
    case 'hacim':
      result = volume.donustur(deger, kaynakBirim, hedefBirim);
      break;
    case 'sicaklik':
      result = temperature.donustur(deger, kaynakBirim, hedefBirim);
      break;
    case 'alan':
      result = area.donustur(deger, kaynakBirim, hedefBirim);
      break;
    case 'zaman':
      result = time.donustur(deger, kaynakBirim, hedefBirim);
      break;
    default:
      return res.status(400).json({ hata: "Geçersiz kategori" });
  }
  
  if (result.hata) {
    return res.status(400).json({ hata: result.hata });
  }
  
  res.json({ 
    sonuc: result.deger,
    bilgi: `${deger} ${kaynakBirim} = ${result.deger} ${hedefBirim}`
  });
});

app.listen(3003, '0.0.0.0', () => {
  console.log('Birim dönüşüm servisi 3003 portunda çalışıyor');
});
