import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final String limit;
  final String createdAt;

  Todo(this.id, this.title, this.description, this.limit, this.createdAt);
}

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier()
      : super([
          Todo("0602a18c-e3cf-4ff8-bb66-b9c9305e9875", "title1", "description1",
              "2022-12-01 10:24:56", "2022-11-01 10:24:56"),
          Todo("d6d88985-5083-489c-a272-9ade30ee4cf7", "title2", "description2",
              "2022-12-02 10:24:56", "2022-11-02 10:24:56"),
          Todo("d0698996-6f42-4cc4-951d-812cbc6d9adb", "title3", "description3",
              "2022-12-03 10:24:56", "2022-11-03 10:24:56"),
          Todo("0602a18c-e3cf-4ff8-bb66-b9c9305e9875", "title4", "description4",
              "2022-12-04 10:24:56", "2022-11-04 10:24:56"),
          Todo("7ea8408f-438e-4484-9370-1949684bc952", "title5", "description5",
              "2022-12-05 10:24:56", "2022-11-05 10:24:56"),
          Todo("b52c9587-91f6-453e-be02-9a481641fad3", "title6", "description6",
              "2022-12-06 10:24:56", "2022-11-06 10:24:56"),
          Todo("1b1bd606-ade2-4c4a-b7a3-df50bffda96d", "title7", "description7",
              "2022-12-07 10:24:56", "2022-11-07 10:24:56"),
          Todo("fea42d00-f1c4-47a5-a37e-d715660912ac", "title8", "description8",
              "2022-12-08 10:24:56", "2022-11-08 10:24:56"),
        ]);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void removeTodo(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void update(Todo todo) {
    state = [
      for (final st in state)
        if (st.id == todo.id) todo else st
    ];
  }
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends ConsumerWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Todo リストの内容に変化があるとウィジェットが更新される
    List<Todo> todos = ref.watch(todosProvider);

    // スクロール可能なリストビューで Todo リストの内容を表示
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo list"),
      ),
      body: Center(
        child: Column(children: [
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {}, child: const Icon(Icons.add)),
              )
            ],
          ),
          Expanded(
              child: SlidableAutoCloseBehavior(
                  child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: ((context, index) => TodoItem(todo: todos[index])),
          ))),
        ]),
      ),
    );
  }
}

class TodoItem extends ConsumerWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: Key(todo.id),
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            ref.read(todosProvider.notifier).removeTodo(todo.id);
          },
        ),
        children: [
          SlidableAction(
              backgroundColor: Colors.lightGreen,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
              onPressed: ((context) =>
                  {ref.read(todosProvider.notifier).removeTodo(todo.id)})),
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: ((context) => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoEditPage(
                        todo: todo,
                      ),
                    ),
                  )
                }),
          ),
        ],
      ),
      child: Card(
        // margin: const EdgeInsets.all(4.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.title,
                style: const TextStyle(fontSize: 25.0),
              ),
              Text(
                todo.description,
                style: const TextStyle(fontSize: 15.0),
              ),
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 1,
                    child: Text("limit: ${todo.limit}"),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("created_at: ${todo.createdAt}"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoEditPage extends ConsumerWidget {
  final Todo todo;

  late String title = todo.title;
  late String description = todo.description;
  late String limit = todo.limit;

  TodoEditPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const textStyle = TextStyle(fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        title: const Text("edit page"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: Text("Title", style: textStyle)),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: TextEditingController(text: todo.title),
                    style: textStyle,
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                )
              ],
            ),
            const Divider(),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: Text("Description", style: textStyle)),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: TextEditingController(text: todo.description),
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    style: textStyle,
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                )
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(child: Text("Limit", style: textStyle)),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: TextEditingController(text: todo.limit),
                    style: textStyle,
                    onChanged: (value) {
                      limit = value;
                    },
                  ),
                )
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                    child: Text("ID",
                        style: TextStyle(fontSize: 20, color: Colors.grey))),
                Expanded(
                  flex: 3,
                  child: Text(todo.id,
                      style: const TextStyle(fontSize: 20, color: Colors.grey)),
                )
              ],
            ),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("cancel"),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    ref.read(todosProvider.notifier).update(Todo(
                        todo.id, title, description, limit, todo.createdAt));
                    Navigator.pop(context);
                  },
                  child: const Text("save"),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
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
