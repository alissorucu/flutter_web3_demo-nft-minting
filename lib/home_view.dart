import 'package:flutter/material.dart';
import 'package:flutter_web3/ethers.dart';
import 'package:flutter_web3_demo__nft_minting/controller.dart';
import 'package:flutter_web3_demo__nft_minting/token_model.dart';
import 'package:flutter_web3_demo__nft_minting/utils.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;
import 'dart:math' as math;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double get screenwidth => MediaQuery.of(context).size.width;

  int get columnCount => screenwidth > 700 ? 7 : 3;

  int get rowCount => screenwidth > 700 ? 3 : 7;

  double get margin {
    if (screenwidth > 900) {
      return 25;
    }else if (screenwidth > 700 && screenwidth < 900) {
      return 15;
    }  else {
      return 10;
    }
  }

  double get ratio => (screenwidth / 1300 * (7/columnCount));
  double get textRatio => (screenwidth / 1300 );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/background.jpg"), fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Padding(
            padding: Paddings.padding25,
            child: Column(
              children: [
                Spaces.vertical25,
                Text(
                  "Neo The Matrix Nft Collection",
                  style: Styles.matrix(70 * textRatio),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.width(0.05)),
                buttons(),
                SizedBox(height: context.height(0.1)),
                
                Consumer<MainController>(
                  builder: (context, state, ch) {
                    return state.tokens.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: MyColors.darkGreen,
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: ((context.width(1) - (200 * ratio)) / columnCount) * rowCount + 100,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.tokens.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columnCount,
                                ),
                                itemBuilder: (c, i) {
                                  TokenModel token = state.tokens[i];
                                  return Padding(
                                    padding: EdgeInsets.all((context.width(1) - (300 * ratio)) / columnCount/20),
                                    child: SizedBox(
                                            width: (context.width(1) - (300 * ratio)) / columnCount,
                                            height: (context.width(1) - (300 * ratio)) / columnCount,
                                      child: Stack(
                                                                       
                                        clipBehavior: Clip.hardEdge,
                                        children: [
                                          Container(
                                            width: (context.width(1) - (300 * ratio)) / columnCount,
                                            height: (context.width(1) - (300 * ratio)) / columnCount,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: MyColors.lightGreen,
                                                ),
                                                image: DecorationImage(image: NetworkImage(token.image), fit: BoxFit.cover)),
                                          ),
                                          Positioned(
                                              right: 10,
                                              bottom: 5,
                                              child: Text(
                                                token.name,
                                                style: Styles.normal(15 * ratio),
                                              )),
                                          Positioned(
                                              left: 10,
                                              top: 5,
                                              child: Text(
                                                "#" + token.id.toString(),
                                                style: Styles.normal(12 * ratio),
                                              )),
                                          if (token.hasSold)
                                            Center(
                                              child: Transform.rotate(
                                                angle: -math.pi / 4,
                                                child: Text(
                                                  "SOLD",
                                                  style: Styles.matrix(45 * ratio),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        connectButton(),
        SizedBox(width: context.width(0.1)),
        mintButton(),
        SizedBox(width: context.width(0.1)),
        showResultButton(),
      ],
    );
  }

  TextButton showResultButton() {
    return TextButton(
        onPressed: () async {
          int? id = await context.read<MainController>().onTransactionComp();

          if (id != null) {
            showDialog(
                context: context,
                builder: (c) {
                  TokenModel token = context.read<MainController>().tokens[id];
                  return AlertDialog(
                    title: Text(
                      "You minted token#${token.id}",
                      style: Styles.normal(60 * ratio),
                    ),
                    backgroundColor: Colors.transparent,
                    content: Stack(
                      //fit: StackFit.passthrough,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Container(
                          width: context.width(0.25),
                          height: context.width(0.25),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: MyColors.lightGreen,
                              ),
                              image: DecorationImage(image: NetworkImage(token.image), fit: BoxFit.cover)),
                        ),
                        Positioned(
                            right: 10,
                            bottom: 5,
                            child: Text(
                              token.name,
                              style: Styles.normal(15 * ratio),
                            )),
                        Positioned(
                            left: 10,
                            top: 5,
                            child: Text(
                              "#" + token.id.toString(),
                              style: Styles.normal(12 * ratio),
                            )),
                      ],
                    ),
                  );
                });
          } else {
            showDialog(
                context: context,
                builder: (c) {
                  return AlertDialog(
                    title: Text(
                      "Wait for transaction result...",
                      style: Styles.matrix(60 * textRatio),
                    ),
                    backgroundColor: MyColors.dark,
                  );
                });
          }
        },
        child: Text(
          "SHOW TRANSACTION RESULT",
          style: Styles.matrix(35 * textRatio),
        ));
  }

  TextButton mintButton() {
    return TextButton(
        onPressed: () async {
          await context.read<MainController>().mint(context, textRatio);
        },
        child: Text(
          "MINT",
          style: Styles.matrix(35 * textRatio),
        ));
  }

  TextButton connectButton() {
    return TextButton(
        onPressed: () async {
          context.read<MainController>().connect(context, textRatio);
        },
        child: Text(
          "CONNECT",
          style: Styles.matrix(35 * textRatio),
        ));
  }
}
