import 'package:flutter/material.dart';
import 'package:usdt_bcv/config/environment.dart';
import 'package:usdt_bcv/config/app_router.dart';
import 'package:usdt_bcv/config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.initEnvironment();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'USDT vs BCV',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
