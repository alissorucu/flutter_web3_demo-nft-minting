import 'package:flutter/material.dart';
import 'package:flutter_web3_demo__nft_minting/controller.dart';
import 'package:flutter_web3_demo__nft_minting/home_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
                ChangeNotifierProvider<MainController>(create: (context) => MainController()),

      ],
      child: const MaterialApp(
        title: 'NeoTheMatrix Minting Site',
        themeMode: ThemeMode.dark,
        home:  HomeView(),
      ),
    );
  }
}

