from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np

app = Flask(__name__)
CORS(app)  # CORS ekle

@app.route('/ortalama', methods=['POST'])
def ortalama():
    data = request.get_json()
    sayilar = data.get('sayilar', [])
    if not sayilar:
        return jsonify({"hata": "Boş dizi gönderildi"}), 400
    return jsonify({"sonuc": float(np.mean(sayilar))})

@app.route('/medyan', methods=['POST'])
def medyan():
    data = request.get_json()
    sayilar = data.get('sayilar', [])
    if not sayilar:
        return jsonify({"hata": "Boş dizi gönderildi"}), 400
    return jsonify({"sonuc": float(np.median(sayilar))})

@app.route('/standart-sapma', methods=['POST'])
def standart_sapma():
    data = request.get_json()
    sayilar = data.get('sayilar', [])
    if not sayilar or len(sayilar) < 2:
        return jsonify({"hata": "En az iki sayı gereklidir"}), 400
    return jsonify({"sonuc": float(np.std(sayilar))})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3002)