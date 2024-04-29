import 'dart:async';

class Property<T> {
  Property(this.value) {
    _controller.stream.listen((T data) {
      value = data;
    });
  }

  T value;
  final _controller = StreamController<T>.broadcast();
  Sink<T> get streamSink => _controller.sink;
  Stream<T> get stream => _controller.stream;

  sink(T data) {
    if (_controller.isClosed) return;
    value = data;
    streamSink.add(data);
  }

  set(T data) {
    value = data;
  }

  reSink() {
    if (_controller.isClosed) return;
    streamSink.add(value);
  }

  void dispose() {
    _controller.close();
  }
}
