import 'package:flutter/material.dart';
import 'package:price_scanner_app/blocs/item.bloc.dart';
import 'package:price_scanner_app/item_details.dart';

class NavigationService {
  List<String> mainPageRouteStack = ["Settings"];
  BuildContext context;
  NavigationService(this.context);

  _pushPage(dynamic page) async {
    return await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (ctx, animation, secAndimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  _pushPageAndBlock(dynamic page) async {
    return await Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (ctx, animation, secAndimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
      ModalRoute.withName('/'),
    );
  }

  // @override
  goBack(dynamic resault)  {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(resault);
    }
  }

  goToItemPage(ItemPageBloc bloc) async {
    if (mainPageRouteStack.isEmpty || mainPageRouteStack.last != "Home") {
      mainPageRouteStack.add("Home");
      return await _pushPageAndBlock(itemDetails(
        bloc: bloc,
      ));
    }
  }

  // goToSettingsPage(SettingsBlocPage bloc) async {
  //   if (mainPageRouteStack.isEmpty || mainPageRouteStack.last != "Settings") {
  //     mainPageRouteStack.add("Settings");
  //     return await _pushPage(SettingPage(
  //       bloc: bloc,
  //     ));
  //   }
  // }
}
