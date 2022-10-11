import 'package:bitcoin/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String pickedCurrency = 'AUD';

  DropdownButton<String> dropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      var newMenu = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );

      dropDownItems.add(newMenu);
    }

    return DropdownButton<String>(
        value: pickedCurrency,
        items: dropDownItems,
        onChanged: (value) {
          setState(() {
            pickedCurrency = value.toString();
            getCoin();
          });
        });
  }

  CupertinoPicker cupertino() {
    List<Text> picker = [];
    for (String currency in currenciesList) {
      picker.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 35.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          pickedCurrency = currenciesList[selectedIndex];
          getCoin();
        });
      },
      children: picker,
    );
  }


  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getCoin() async {
    isWaiting = true;
    try {
      var coin = await CoinData().getCoinData(pickedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = coin;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCoin();
  }

  Column makeCards() {
    List<Crypto> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        Crypto(
          cryptoCurrency: crypto,
          value: isWaiting ? '?' : coinValues[crypto].toString(),
          pickedCurrency: pickedCurrency,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              makeCards(),
              // Crypto(
              //   cryptoCurrency: 'BTC',
              //   value: isWaiting ? '?' : coinValues['BTC'].toString(),
              //   pickedCurrency: pickedCurrency,
              // ),
              // Crypto(
              //   cryptoCurrency: 'ETH',
              //   value: isWaiting ? '?' : coinValues['ETH'].toString(),
              //   pickedCurrency: pickedCurrency,
              // ),
              // Crypto(
              //   cryptoCurrency: 'LTC',
              //     value: isWaiting ? '?' : coinValues['LTC'].toString(),
              //   pickedCurrency: pickedCurrency,
              // ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? cupertino() : dropDown(),
          ),
        ],
      ),
    );
  }
}

class Crypto extends StatelessWidget {
  const Crypto({
    Key? key,
    required this.cryptoCurrency,
    required this.value,
    required this.pickedCurrency,
  }) : super(key: key);

  final String cryptoCurrency;
  final String value;
  final String pickedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $pickedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
