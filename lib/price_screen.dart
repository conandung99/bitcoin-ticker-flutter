import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  bool isWaiting = true;
  String selectedCurrency = currenciesList.first;
  Map<String, String> exchangeRate = {};

  void initMap() {
    for (String crypto in cryptoList) {
      exchangeRate.addAll({crypto: '?'});
    }
  }

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
          for (String crypto in cryptoList) {
            exchangeRate[crypto] = '?';
          }
        });
        updateUI();
      },
      looping: true,
      children: list,
    );
  }

  void updateUI() async {
    for (String crypto in cryptoList) {
      String rate = '?';
      var rateData =
          await coinData.getCoinData(from: crypto, to: selectedCurrency);
      if (rateData != null) {
        double value = rateData['rate'];
        rate = value.toInt().toString();
      } else
        rate = 'error';
      exchangeRate[crypto] = rate;
    }
    setState(() => isWaiting = false);
  }

  List<Widget> makeCard() {
    List<Widget> list = [];
    for (String crypto in cryptoList) {
      list.add(
        CoinCard(
            currentCrypto: crypto,
            rate: isWaiting ? '?' : exchangeRate[crypto],
            selectedCurrency: selectedCurrency),
      );
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    initMap();
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
            child: Column(
              children: makeCard(),
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

class CoinCard extends StatelessWidget {
  const CoinCard({
    Key key,
    @required this.currentCrypto,
    @required this.rate,
    @required this.selectedCurrency,
  }) : super(key: key);

  final String currentCrypto;
  final String rate;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
