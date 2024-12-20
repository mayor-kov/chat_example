import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessage extends ChatEvent {
  final String content;

  SendMessage(this.content);

  @override
  List<Object?> get props => [content];
}

class ReceiveMessage extends ChatEvent {
  final String content;

  ReceiveMessage(this.content);

  @override
  List<Object?> get props => [content];
}

class ConnectWebSocket extends ChatEvent {}
