import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:flutter_web3_demo__nft_minting/abi.dart';
import 'package:flutter_web3_demo__nft_minting/token_model.dart';
import 'package:flutter_web3_demo__nft_minting/utils.dart';
import 'package:http/http.dart' as http;

class MainController extends ChangeNotifier {
  List<TokenModel> tokens = [];

  String currentAddress = '';

  bool get isEnabled => ethereum != null;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  late Web3Provider myProvider;
  late Contract neoTheMatrixContract;

  Future<void> connect(BuildContext context,double ratio) async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) currentAddress = accs.first;
      await ethereum!.walletSwitchChain(4);
      myProvider = Web3Provider.fromEthereum(ethereum!);
    
      neoTheMatrixContract = Contract.fromSigner("0x40fE74eb83Dd4642463F6d34b59452cF8fa2c49f", abi, myProvider.getSigner());
      getNftsMetaData();
    } else {
      showWEB3ALERT(context,ratio);
    }
  }

  Future<void> mint(BuildContext context,double ratio) async {
    if (isEnabled) {
      if (!isConnected) {
        await connect(context,ratio);
      }

      ethereum!.walletSwitchChain(4);
      await neoTheMatrixContract.send("safeMint", [], TransactionOverride(value: BigInt.from(2000000000000000)));
      
      

    } else {
      showWEB3ALERT(context,ratio);
    }
  }
    List<int> soldTokens = [];
 


  Future<void> getNftsMetaData() async {
    if (tokens.isEmpty) {
      var response = await http.get(Uri.parse("https://my-json-server.typicode.com/alissorucu/flutter_web3_demo-nft-minting/tokens/"));
       soldTokens = (await neoTheMatrixContract.call("getSoldTokens") as List).map((e) => int.tryParse(e.toString())!).toList(); //"[2,3,4,5]"

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        for (int i = 0; i < data.length; i++) {
          var item = data[i];

          tokens.add(TokenModel.fromJson(item, soldTokens.contains(i)));
        }

        notifyListeners();
      }
    }
  }


  Future<int?> onTransactionComp( ) async {
    await  Future.delayed(const Duration(seconds: 2));
    List<int> newTokens = (await neoTheMatrixContract.call("getSoldTokens") as List).map((e) => int.tryParse(e.toString())!).toList();

      int? mintedToken;
      for (var tokenId in newTokens) {
        if(!soldTokens.contains(tokenId)){
          mintedToken = tokenId;
          tokens[mintedToken].hasSold =true;
          notifyListeners();
        }
        
      }
      return mintedToken;
  }
  showWEB3ALERT(BuildContext context,double ratio) {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            backgroundColor: MyColors.dark,
            title: Text(
              "Please use a webThree supported browser",
              style: Styles.matrix(50*ratio),
            ),
          );
        });
  }
}
