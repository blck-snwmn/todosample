import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todosample/todo.dart';
import 'package:uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@riverpod
class TodosNotifier extends _$TodosNotifier {
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

  @override
  List<Todo> build() {
    return [
      const Todo(
          id: "0602a18c-e3cf-4ff8-bb66-b9c9305e9875",
          title: "title1",
          description: "description1",
          limit: "2022-12-01 10:24:56",
          createdAt: "2022-11-01 10:24:56"),
      const Todo(
          id: "0602a18c-e3cf-4ff8-bb66-b9c9305e9875",
          title: "title2",
          description: "description2",
          limit: "2022-12-01 10:24:56",
          createdAt: "2022-11-01 10:24:56"),
      const Todo(
          id: "0602a18c-e3cf-4ff8-bb66-b9c9305e9875",
          title: "title3",
          description: "description3",
          limit: "2022-12-01 10:24:56",
          createdAt: "2022-11-01 10:24:56"),
      const Todo(
          id: "0602a18c-e3cf-4ff8-bb66-b9c9305e9875",
          title: "title4",
          description: "description4",
          limit: "2022-12-01 10:24:56",
          createdAt: "2022-11-01 10:24:56"),
    ];
  }
}

// final todosProvider = NotifierProvider<TodosNotifier, List<Todo>>(() {
//   return TodosNotifier();
// });

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
    List<Todo> todos = ref.watch(todosNotifierProvider);

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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoAddPage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.add)),
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
            ref.read(todosNotifierProvider.notifier).removeTodo(todo.id);
          },
        ),
        children: [
          SlidableAction(
              backgroundColor: Colors.lightGreen,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
              onPressed: ((context) => {
                    ref.read(todosNotifierProvider.notifier).removeTodo(todo.id)
                  })),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                      ref.read(todosNotifierProvider.notifier).update(Todo(
                            id: todo.id,
                            title: title,
                            description: description,
                            limit: limit,
                            createdAt: todo.createdAt,
                          ));
                      Navigator.pop(context);
                    },
                    child: const Text("save"),
                  ),
                  const Spacer(),
                ],
              ),
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
                        style:
                            const TextStyle(fontSize: 20, color: Colors.grey)),
                  )
                ],
              ),
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: QrImage(
                        padding: const EdgeInsets.all(10),
                        data: todo.id,
                        foregroundColor: Colors.amberAccent,
                        backgroundColor: Colors.blueGrey,
                        version: QrVersions.auto,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TodoAddPage extends ConsumerWidget {
  String title = "";
  String description = "";
  String limit = "";

  TodoAddPage({super.key});

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
                    if (title == "" || description == "" || limit == "") return;
                    ref.read(todosNotifierProvider.notifier).addTodo(Todo(
                          id: (const Uuid()).v4().toString(),
                          title: title,
                          description: description,
                          limit: limit,
                          createdAt: DateTime.now().toString(),
                        ));
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
