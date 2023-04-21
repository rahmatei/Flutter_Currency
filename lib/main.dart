import 'package:currency/models/Currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'naz',
        textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'naz',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'naz',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            displayMedium: TextStyle(
                fontFamily: 'naz',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', ''),
      ],
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Currency> currency = [];
  String time =
      "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}";

  Future getResponseService() async {
    String url =
        "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
    await http.get(Uri.parse(url)).then((res) {
      if (currency.isEmpty) {
        if (res.statusCode == 200) {
          List jsonList = jsonDecode(res.body);
          if (jsonList.isNotEmpty) {
            for (var i = 0; i < jsonList.length; i++) {
              setState(() {
                currency.add(
                  Currency(
                    id: jsonList[i]["id"],
                    title: jsonList[i]["title"],
                    price: jsonList[i]["price"],
                    changes: jsonList[i]["changes"],
                    status: jsonList[i]["status"],
                  ),
                );
              });
            }
          }
        }
      }
    });
  }

  @override
  void initState() {
    getResponseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    time =
        "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Image.asset("assets/images/icon.png"),
            Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  "قیمت بروز سکه و ارز",
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            Expanded(
                child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Image.asset("assets/images/menu.png"),
            )),
            const SizedBox(
              width: 15,
            ),
          ],
          elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset('assets/images/qicon.png'),
                const SizedBox(
                  width: 7,
                ),
                const Text('نرخ ارز آزاد چیست ؟')
              ],
            ),
            const Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                  'نرخ ارزها در معاملات نقدی روزانه است معملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله ارز و ریاال را با هم تبادل می نمایند.',
                  textDirection: TextDirection.rtl),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: Colors.black38,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'نام آزاد ارز ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'قیمت ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    ' تغییر',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: ((context, index) {
                    return ItemList(
                      currency: currency[index],
                      index: index,
                    );
                  })),
            ),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: Colors.black12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    child: TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.orange,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),
                      ),
                      onPressed: () {
                        getResponseService();
                        _ShowSnackBar(context);
                        //_showDialog(context);
                        time =
                            "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}";
                      },
                      icon: const Icon(CupertinoIcons.refresh_bold,
                          color: Colors.black),
                      label: Text(
                        "بروزرسانی",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ),
                  Text(
                    'آخرین بروز رسانی $time',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _ShowSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      elevation: 4.0, // سایه ملایم
      shape: RoundedRectangleBorder(
          // گرد کردن قاب snackbar
          borderRadius: BorderRadius.circular(10)),
      content: Text(
        "اطلاعات بروزرسانی گردید.",
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              // کپی کردن و اضافه کردن خصوصیت های جدید
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    ));
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("پیام"),
        content: Text("اطلاعات بروزرسانی گردید."),
        actions: [
          TextButton(
            child: Text("تأیید"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class ItemList extends StatefulWidget {
  final Currency currency;
  final int index;

  const ItemList({
    required this.currency,
    required this.index,
    super.key,
  });

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: Colors.white,
            border: Border.all(
              color: Colors.black12,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black12, offset: Offset(1, 1))
            ]),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(widget.currency.title!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center),
          Text(widget.currency.price!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center),
          Text(
            widget.currency.changes!,
            style: widget.currency.status == 'n'
                ? const TextStyle(
                    color: Colors.red,
                  )
                : const TextStyle(color: Colors.green),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }
}
