// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    TodoListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TodoListPage(),
      );
    },
    TodoEditRoute.name: (routeData) {
      final args = routeData.argsAs<TodoEditRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoEditPage(
          key: args.key,
          todo: args.todo,
        ),
      );
    },
    TodoAddRoute.name: (routeData) {
      final args = routeData.argsAs<TodoAddRouteArgs>(
          orElse: () => const TodoAddRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoAddPage(key: args.key),
      );
    },
  };
}

/// generated route for
/// [TodoListPage]
class TodoListRoute extends PageRouteInfo<void> {
  const TodoListRoute({List<PageRouteInfo>? children})
      : super(
          TodoListRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TodoEditPage]
class TodoEditRoute extends PageRouteInfo<TodoEditRouteArgs> {
  TodoEditRoute({
    Key? key,
    required Todo todo,
    List<PageRouteInfo>? children,
  }) : super(
          TodoEditRoute.name,
          args: TodoEditRouteArgs(
            key: key,
            todo: todo,
          ),
          initialChildren: children,
        );

  static const String name = 'TodoEditRoute';

  static const PageInfo<TodoEditRouteArgs> page =
      PageInfo<TodoEditRouteArgs>(name);
}

class TodoEditRouteArgs {
  const TodoEditRouteArgs({
    this.key,
    required this.todo,
  });

  final Key? key;

  final Todo todo;

  @override
  String toString() {
    return 'TodoEditRouteArgs{key: $key, todo: $todo}';
  }
}

/// generated route for
/// [TodoAddPage]
class TodoAddRoute extends PageRouteInfo<TodoAddRouteArgs> {
  TodoAddRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          TodoAddRoute.name,
          args: TodoAddRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'TodoAddRoute';

  static const PageInfo<TodoAddRouteArgs> page =
      PageInfo<TodoAddRouteArgs>(name);
}

class TodoAddRouteArgs {
  const TodoAddRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'TodoAddRouteArgs{key: $key}';
  }
}
