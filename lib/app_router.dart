import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todosample/main.dart';
import 'package:todosample/todo.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: TodoListRoute.page, initial: true),
        AutoRoute(page: TodoEditRoute.page),
        AutoRoute(page: TodoAddRoute.page),
      ];
}
