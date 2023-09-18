import 'package:body_detection_example/pages/home_view.dart';
import 'package:body_detection_example/pages/splash_view.dart';
import 'package:body_detection_example/providers/counter_bloc.dart';
import 'package:body_detection_example/providers/counter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => CounterBloC(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final counterBloc = CounterBloC();
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PushUpBloc(),
      child: MaterialApp(
        home: SplashView(),
        theme: ThemeData(
          useMaterial3: true
        ),
      ),
    );
  }
}
