import 'network_status_stub.dart'
    if (dart.library.html) 'network_status_web.dart'
    if (dart.library.io) 'network_status_io.dart';

class ConnectionService {
  static Future<bool> hasConnection() => checkOnlineStatus();
  static Stream<bool> get connectionStream => onNetworkStatusChange;
}