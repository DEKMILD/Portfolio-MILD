import 'package:flutter/material.dart';
import 'FoodMenu.dart';
import 'MoneyBox.dart';
import 'package:http/http.dart'as http;
import 'ExchangeRate.dart';


void main() {
  runApp(MyApp());
}

// สร้าง widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      home: MyHomePage(),
      theme: ThemeData(primarySwatch: Colors.pink),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

//แสดงผลข้อมูล
  late ExchangeRate _dataFromAPI;
  @override
  void initState() {
    super.initState();
    getExchangeRate();
    
  }
 Future <ExchangeRate> getExchangeRate() async{
      var url =  Uri.parse('https://api.exchangerate-api.com/v4/latest/THB');
      var response = await http.get(url);
      _dataFromAPI= exchangeRateFromJson(response.body); //json => dart object
      return _dataFromAPI; 
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text("แปลงสกุลเงินแบบตัวแม่",
                      style: TextStyle(fontSize: 25,
                       color: Colors.white,
                       fontWeight: FontWeight.bold
 ),
          ),
        ),
        body: FutureBuilder(
          future: getExchangeRate(),
          builder: (BuildContext context, AsyncSnapshot <dynamic> snapshot){
            if(snapshot.connectionState == ConnectionState.done){
                var result = snapshot.data;
                double amount = 10000;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                        children: [
                          MoneyBox("สกุลเงิน (THB)", amount, Colors.lightBlue, 150),
                          SizedBox(height: 5,),
                          MoneyBox("NZD", amount*result.rates["NZD"], Colors.green, 100),
                          SizedBox(height: 5,),
                          MoneyBox("USD", amount*result.rates["USD"], Colors.red, 100),
                          SizedBox(height: 5,),
                          MoneyBox("GBP", amount*result.rates["GBP"], Colors.pink, 100),
                          SizedBox(height: 5,),
                          MoneyBox("JPY", amount*result.rates["JPY"], Colors.orange, 100),
                          SizedBox(height: 5,),
                          MoneyBox("EUR", amount*result.rates["EUR"], Color.fromARGB(255, 54, 222, 244), 100),
                          SizedBox(height: 5,),
                          MoneyBox("AUD", amount*result.rates["AUD"], Color.fromARGB(255, 238, 54, 244), 100),
                          SizedBox(height: 5,),
                          MoneyBox("KRW", amount*result.rates["KRW"], Color.fromARGB(255, 54, 244, 197), 100),
                  
                        ],
                    ),
                  ),
                );
            }
              return LinearProgressIndicator();
        },) 
        );
  }
}