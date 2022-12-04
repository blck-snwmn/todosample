import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [
    Todo(
        "title1", "description1", "2022-12-01 10:24:56", "2022-11-01 10:24:56"),
    Todo(
        "title2", "description2", "2022-12-02 10:24:56", "2022-11-02 10:24:56"),
    Todo(
        "title3", "description3", "2022-12-03 10:24:56", "2022-11-03 10:24:56"),
    Todo(
        "title4", "description4", "2022-12-04 10:24:56", "2022-11-04 10:24:56"),
    Todo(
        "title5", "description5", "2022-12-05 10:24:56", "2022-11-05 10:24:56"),
    Todo(
        "title6", "description6", "2022-12-06 10:24:56", "2022-11-06 10:24:56"),
    Todo(
        "title7", "description7", "2022-12-07 10:24:56", "2022-11-07 10:24:56"),
    Todo(
        "title8", "description8", "2022-12-08 10:24:56", "2022-11-08 10:24:56"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: ((context, index) => TodoItem(
              title: todos[index].title,
              description: todos[index].description,
              limit: todos[index].limit,
              createdAt: todos[index].createdAt)),
        ),
      ),
    );
  }
}

class Todo {
  final String title;
  final String description;
  final String limit;
  final String createdAt;

  Todo(this.title, this.description, this.limit, this.createdAt);
}

class TodoItem extends StatelessWidget {
  final String title;
  final String description;
  final String limit;
  final String createdAt;

  const TodoItem(
      {super.key,
      required this.title,
      required this.description,
      required this.limit,
      required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 25.0),
          ),
          Text(
            description,
            style: const TextStyle(fontSize: 15.0),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("limit: $limit"),
              const Spacer(),
              Text("created_at: $createdAt"),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
