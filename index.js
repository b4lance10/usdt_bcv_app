const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const cors = require('cors');

const app = express();
app.use(cors());

const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0';

async function getBCVRate() {
    try {
        const instance = axios.create({
            httpsAgent: new (require('https').Agent)({
                rejectUnauthorized: false
            })
        });

        const { data } = await instance.get('https://www.bcv.org.ve/')
        const $ = cheerio.load(data);

        let rateText = $('#dolar strong').text();
        if (!rateText) {
            rateText = $('#dolar').text().trim();
        }
        const rate = parseFloat(rateText.replace(',', '.'));
        return rate || null;

    } catch (error) {
        console.error('Error obteniendo BCV:', error.message);
        return null;
    }
}

async function getUSDTRate() {
    try {
        const url = 'https://p2p.binance.com/bapi/c2c/v2/friendly/c2c/adv/search';
        const payload = {
            "proMerchantAds": false,
            "page": 1,
            "rows": 10,
            "payTypes": ["PagoMovil"],
            "countries": [],
            "publisherType": null,
            "asset": "USDT",
            "fiat": "VES",
            "tradeType": "BUY",
            "transAmount": "75000"
        };

        const { data } = await axios.post(url, payload);

        if (data && data.data && data.data.length > 0) {
            const ads = data.data;
            let sum = 0;
            let count = 0;

            ads.forEach(ad => {
                const price = parseFloat(ad.adv.price);
                if (price) {
                    sum += price;
                    count++;
                }
            });

            return count > 0 ? (sum / count) : null;
        }
        return null;

    } catch (error) {
        console.error('Error obteniendo USDT:', error.message);
        return null;
    }
}

app.get('/api/tasas', async (req, res) => {
    const [bcv, usdt] = await Promise.all([
        getBCVRate(),
        getUSDTRate()
    ]);

    res.json({
        ok: true,
        fecha: new Date().toISOString(),
        data: {
            precio_bcv: bcv,
            precio_usdt: usdt ? parseFloat(usdt.toFixed(2)) : null,
            nota: "El precio USDT es un promedio de las 10 mejores ofertas para ~75.000 VES"
        }
    });
});

app.listen(PORT, HOST, () => {
    console.log(`Servidor corriendo en http://172.16.0.4:${PORT}`);
});

module.exports = app;