import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String rate = '?';
  String currentCrypto = 'BTC';
  String selectedCurrency = currenciesList.first;
  CoinData coinData = CoinData();

  Widget getAndroidDropDown() {
    List<DropdownMenuItem<String>> list = [];
    for (String currency in currenciesList) {
      list.add(DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      ));
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: list,
      onChanged: (value) async {
        setState(() {
          selectedCurrency = value;
        });
        updateUI();
      },
    );
  }

  Widget getIosPicker() {
    List<Text> list = [];
    for (String currency in currenciesList) {
      list.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      // backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (int value) async {
        setState(() {
          selectedCurrency = currenciesList[value];
        });
        updateUI();
      },
      looping: true,
      children: list,
    );
  }

  void updateUI() async {
    var rateData =
        await coinData.getCoinData(from: currentCrypto, to: selectedCurrency);
    setState(() {
      if (rateData != null) {
        double value = rateData['rate'];
        rate = value.toInt().toString();
      } else
        rate = 'error';
    });
  }

  @override
  void initState() {
    super.initState();
    updateUI();
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
          Padding(
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
                  '1 $currentCrypto = $rate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIosPicker() : getAndroidDropDown(),
          ),
        ],
      ),
    );
  }
}
