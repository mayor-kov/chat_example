class Message {
  final String content;
  final DateTime timestamp;
  final bool isMe;

  Message({
    required this.content,
    required this.timestamp,
    required this.isMe,
  });
}
