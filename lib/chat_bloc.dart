import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'message_model.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WebSocketChannel _channel =
      WebSocketChannel.connect(Uri.parse('wss://ws.postman-echo.com/raw'));

  StreamSubscription? _webSocketSubscription;

  ChatBloc() : super(ChatInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  void _onConnectWebSocket(ConnectWebSocket event, Emitter<ChatState> emit) {
    _webSocketSubscription = _channel.stream.listen((data) {
      add(ReceiveMessage(data)); // Обрабатываем входящие сообщения.
    });

    emit(ChatLoaded([])); // Начинаем с пустого списка сообщений.
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final newMessage = Message(
        content: event.content,
        timestamp: DateTime.now(),
        isMe: true,
      );

      // Отправляем сообщение через WebSocket.
      _channel.sink.add(event.content);

      emit(ChatLoaded(List.from(currentState.messages)..add(newMessage)));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final newMessage = Message(
        content: event.content,
        timestamp: DateTime.now(),
        isMe: false,
      );

      emit(ChatLoaded(List.from(currentState.messages)..add(newMessage)));
    }
  }

  @override
  Future<void> close() {
    _webSocketSubscription?.cancel();
    _channel.sink.close();
    return super.close();
  }
}
