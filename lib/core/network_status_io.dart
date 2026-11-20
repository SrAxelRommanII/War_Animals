import 'dart:async';
import 'dart:io';

Future<bool> checkOnlineStatus() async {
  try {
    final result = await InternetAddress.lookup('8.8.8.8')
        .timeout(const Duration(seconds: 3));
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

Stream<bool> get onNetworkStatusChange {
  return Stream.periodic(const Duration(seconds: 5))
      .asyncMap((_) => checkOnlineStatus())
      .distinct();
}