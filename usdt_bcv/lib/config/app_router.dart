
import 'package:go_router/go_router.dart';
import 'package:usdt_bcv/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/', 
      builder: (context, state) =>  HomeScreen()
    ) , 
  ]
);