import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeController extends GetxController {
  var bcvRate = 0.0.obs;
  var usdtRate = 0.0.obs;
  var isLoading = true.obs;
  
  final amountController = TextEditingController();
  var resultUsdt = 0.0.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchRates();
  }

  Future<void> fetchRates() async {
    try {
      isLoading(true);
      final String urlfinal =  "${dotenv.env['API_URL']}/api/tasas";
      final url = urlfinal;
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ok']) {
          bcvRate.value = (data['data']['precio_bcv'] as num).toDouble();
          usdtRate.value = (data['data']['precio_usdt'] as num).toDouble();
        }
      } else {
        Get.snackbar("Error", "No se pudo conectar al servidor");
      }
    } catch (e) {
      Get.snackbar("Error", "Revisa tu conexión o la IP del servidor");
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void calculateConversion(String value) {
    if (value.isEmpty) {
      resultUsdt.value = 0.0;
      return;
    }
    
    double amountInBCV = double.tryParse(value) ?? 0.0;
    double resultado = amountInBCV * bcvRate.value;

    
    if (usdtRate.value > 0) {
        resultUsdt.value = resultado / usdtRate.value;
    }
  }
}