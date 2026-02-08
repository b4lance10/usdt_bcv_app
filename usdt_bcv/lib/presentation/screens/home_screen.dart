import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:usdt_bcv/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {

  final name = "HomeScreen";
  final controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/logo.png'), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "USDT vs BCV",
                style: GoogleFonts.roboto(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              
              const SizedBox(height: 30),

              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                return Column(
                  children: [
                    _buildRateCard(
                      title: "Tasa Oficial BCV",
                      amount: controller.bcvRate.value,
                      color: Colors.amber[700]!,
                      icon: Icons.account_balance,
                    ),
                    const SizedBox(height: 15),
                    _buildRateCard(
                      title: "Tasa USDT",
                      amount: controller.usdtRate.value,
                      color: Colors.green[600]!,
                      icon: Icons.currency_exchange,
                    ),

                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),

                    Text(
                      "Calculadora de Cambio",
                      style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Monto a pagar en BCV",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: const Icon(Icons.attach_money),
                              suffixText: "BCV",
                            ),
                            onChanged: (val) => controller.calculateConversion(val),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Necesitas vender:", style: GoogleFonts.roboto(color: Colors.grey[600])),
                              Obx(() => Text(
                                "${NumberFormat.currency(symbol: '\$').format(controller.resultUsdt.value)} USDT",
                                style: GoogleFonts.roboto(
                                  fontSize: 22, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800]
                                ),
                              )),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Calculado a tasa Binance promedio",
                            style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 30),
              IconButton(
                onPressed: () => controller.fetchRates(),
                icon: const Icon(Icons.refresh, size: 30, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRateCard({required String title, required double amount, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.roboto(color: Colors.white70, fontSize: 14)),
              Text(
                "${amount.toStringAsFixed(2)} Bs",
                style: GoogleFonts.roboto(
                  color: Colors.white, 
                  fontSize: 28, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 40),
        ],
      ),
    );
  }
}