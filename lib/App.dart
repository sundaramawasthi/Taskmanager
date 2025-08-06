import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AuthGate(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}
