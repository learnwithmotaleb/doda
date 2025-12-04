import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../../core/api/end_point/api_end_points.dart';
import '../../../core/api/services/api.dart';
import '../../../core/utils/app_storage.dart';
import '../model/send_message_model.dart';

class InboxController extends GetxController {
  final textController = TextEditingController();
  final scrollController = ScrollController();

  final participantName = ''.obs;
  final participantEmail = ''.obs;
  final participantProfile = ''.obs;
  final hasText = false.obs;
  final hasTextOrImage = false.obs;

  final messageList = <MessageModel>[].obs;
  final ImagePicker _picker = ImagePicker();


  // Socket
  late IO.Socket socket;

  String? conversationId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    conversationId = args['conversationId'];
    if (conversationId != null) fetchConversation(conversationId!);

    connectToSocket();
  }

  void connectToSocket() {
    final url = "http://10.10.20.52:6002/?id=${AppStorage.uId}&role=${AppStorage.role}";
    print('**********************************************************************');
    print('**********************************************************************');
    print('**********************************************************************');
    log("Connecting to socket: $url");
    socket = IO.io(url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'&role=': AppStorage.role})
          .setReconnectionAttempts(10)
          .enableAutoConnect()
          .build(),
    );

    socket.connect();
    socket.onConnect((_) => log("✅ Socket connected: ${AppStorage.uId}"));
    socket.onDisconnect((_) => log("❌ Socket disconnected"));

    // Only add messages from other users
    // socket.on("new-message", (data) {
    //   if (data["sender"]["_id"] == AppStorage.userID) return;
    //
    //   messagesList.add({
    //     "message": data["message"] ?? '',
    //     "isMe": false,
    //     "isSent": true,
    //     "formattedTime": Helpers.formatTimestamp(data["createdAt"]),
    //     "id": data["_id"],
    //     "type": data["type"] ?? "text",
    //     "files": data["files"],
    //   });
    // });
  }





  void sendMessage() {}



























  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) sendImageMessage(image.path);
  }

  void sendImageMessage(String imagePath) {
    final newMessage = MessageModel(
      imageUrl: imagePath,
      isMe: true,
      time: _getTime(),
    );
    messageList.add(newMessage);
    _scrollToBottom();

    if (conversationId != null) {
      // _sendImageMessageToAPI(imagePath);
    }
  }

  String _getTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Fetch conversation messages from API
  Future<void> fetchConversation(String conversationId) async {
    try {
      await ApiRequest.get(
        endPoint: ApiEndPoints.getConversationById(conversationId),
        isLoading: false.obs,
        fromJson: (json) {
          final conv = json['conversation'];
          final part = json['participant'];

          // Participant info
          participantName.value = part['name'] ?? '';
          participantEmail.value = part['email'] ?? '';
          participantProfile.value = part['profileImage'] ?? '';

          // Messages
          final List<MessageModel> messages = [];
          if (conv['messages'] != null) {
            for (var m in conv['messages']) {
              final sender = m['sender'];
              messages.add(
                MessageModel(
                  id: m['_id'],
                  conversationId: m['conversationId'],
                  text: m['text'],
                  images: List<String>.from(m['images'] ?? []),
                  senderId: sender['id'],
                  senderName: sender['name'],
                  senderProfileImage: sender['profileImage'],
                  isMe: sender['id'] == AppStorage.userId,
                  time: m['createdAt'],
                ),
              );
            }
          }

          messageList.value = messages;
          _scrollToBottom();
          return messages;
        },
      );
    } catch (e) {
      print("Error fetching conversation: $e");
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    socket.dispose();
    textController.dispose();
    super.onClose();
  }
}
