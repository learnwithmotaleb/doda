class MessageModel {
  final String? id;
  final String? conversationId;
  final String? text;
  final List<String>? images;
  final String? senderId;
  final String? senderName;
  final String? imageUrl;
  final String? senderProfileImage;
  final bool isMe;
  final String? time;

  MessageModel({
    this.id,
    this.conversationId,
    this.text,
    this.images,
    this.senderId,
    this.senderName,
    this.senderProfileImage,
    required this.isMe,
    this.time,this.imageUrl,
  });
}
