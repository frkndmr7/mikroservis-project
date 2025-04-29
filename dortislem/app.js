const express = require('express');
const cors = require('cors');
const app = express();

// JSON ve CORS middleware'leri
app.use(express.json());
app.use(cors());

app.post('/topla', (req, res) => {
  const { a, b } = req.body;
  res.json({ sonuc: a + b });
});

app.post('/cikar', (req, res) => {
  const { a, b } = req.body;
  res.json({ sonuc: a - b });
});

app.post('/carp', (req, res) => {
  const { a, b } = req.body;
  res.json({ sonuc: a * b });
});

app.post('/bol', (req, res) => {
  const { a, b } = req.body;
  if (b === 0) {
    return res.status(400).json({ hata: "Sıfıra bölme hatası!" });
  }
  res.json({ sonuc: a / b });
});

app.listen(3001, '0.0.0.0', () => {
  console.log('Matematik servisi 3001 portunda çalışıyor');
});