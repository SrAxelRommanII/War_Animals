import 'dart:async';
import 'dart:html' as html;

Future<bool> checkOnlineStatus() async {
  return html.window.navigator.onLine ?? false;
}

Stream<bool> get onNetworkStatusChange {
  final controller = StreamController<bool>.broadcast();
  html.window.onOnline.listen((_) => controller.add(true));
  html.window.onOffline.listen((_) => controller.add(false));
  return controller.stream;
}