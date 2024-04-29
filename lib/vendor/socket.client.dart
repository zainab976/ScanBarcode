import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef EventHandler<T> = dynamic Function(T data);

class SocketClient {
  WebSocketChannel? channel;
  Map<String, List<EventHandler>> _events =
      HashMap<String, List<EventHandler>>();
  Function? onConnect;
  Function(bool)? onConnectionChange;

  String url;
  bool isConnected = false;
  int ackId = 0;
  Map acks = {};

  SocketClient(this.url);

  connect() {
    _events = HashMap<String, List<EventHandler>>();
    print("connecting");

    channel = WebSocketChannel.connect(
      Uri.parse(url),
    );

    channel!.stream.listen((event) {
      if (event == "connected") {
        isConnected = true;
        updateConnectionStatus();
        if (onConnect != null) {
          onConnect!();
        }
      } else {
        var packet = json.decode(event);
        // Map<String, dynamic> obj = json.decode(event);
        // SocketServerRequest request = SocketServerRequest(request: obj["request"], data: obj['data']);

        if (packet['id'] != null) {
          dynamic ack = acks.remove(packet['id']);
          if (ack is Completer) {
            ack.complete(packet['data']);
          }
        } else {
          _events.forEach((key, value) {
            if (key == packet['event']) {
              value[0](packet['data']);
            }
          });
        }
      }
    }, onError: (err) {
      print("SocketClient $err");
      isConnected = false;
      updateConnectionStatus();
    }, onDone: () {
      isConnected = false;
      updateConnectionStatus();
      Future.delayed(const Duration(seconds: 10), () => connect());
    });
  }

  updateConnectionStatus() {
    if (onConnectionChange != null) {
      onConnectionChange!(isConnected);
    }
  }

  on(String event, EventHandler handler) {
    _events.putIfAbsent(event, () => <EventHandler>[]);
    _events[event]!.add(handler);
  }

  emit(String event, [data]) {
    var packet = {};
    packet['event'] = event;
    packet['data'] = data;
    channel!.sink.add(json.encode(packet));
  }

  Future<String> emitWithAck(String event, dynamic data) {
    final Completer<String> completer = Completer<String>();
    var packet = {};

    acks['$ackId'] = completer;
    packet['id'] = '${ackId++}';

    packet['event'] = event;
    packet['data'] = data;

    channel!.sink.add(json.encode(packet));

    return completer.future;
  }
}
