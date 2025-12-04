// // ------------------ INBOX CONTROLLER ---------------------
// import 'dart:io';
// import 'package:e_commerce/core/api/model/basic_success_model.dart';
// import 'package:e_commerce/core/utils/app_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../core/api/end_point/api_end_points.dart';
// import '../../../core/api/services/api_request.dart';
// import '../../../core/helpers/helpers.dart';
// import '../../../core/utils/basic_import.dart';
// import 'dart:developer';
// import '../model/my_conversion_model_model.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class InboxController extends GetxController {
//   final textController = TextEditingController();
//   final RxBool isLoading = false.obs;
//   final RxBool isPaginationLoading = false.obs;
//   final Rx<XFile?> selectedImage = Rx<XFile?>(null);
//
//   String? receiverId;
//   String? roomId;
//   String? name;
//   String? avatar;
//   late IO.Socket socket;
//   RxList<Map<String, dynamic>> messagesList = <Map<String, dynamic>>[].obs;
//
//   // Pagination
//   int limit = 20;
//   int skip = 0;
//   bool hasMore = true;
//
//   @override
//   void onInit() {
//     super.onInit();
//     receiverId = Get.parameters['receiverId'];
//     roomId = Get.parameters['roomId'];
//     name = Get.parameters['name'];
//     avatar = Get.parameters['avatar'];
//     _initSocket();
//     if (roomId?.isNotEmpty ?? false) fetchMessages();
//   }
//
//   void _initSocket() {
//     socket = IO.io(
//       "ws://10.10.20.44:3333",
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .setQuery({'userId': AppStorage.userID})
//           .setReconnectionAttempts(10)
//           .enableAutoConnect()
//           .build(),
//     );
//
//     socket.connect();
//     socket.onConnect((_) => log("✅ Socket connected: ${AppStorage.userID}"));
//     socket.onDisconnect((_) => log("❌ Socket disconnected"));
//
//     // Only add messages from other users
//     socket.on("new-message", (data) {
//       if (data["sender"]["_id"] == AppStorage.userID) return;
//
//       messagesList.add({
//         "message": data["message"] ?? '',
//         "isMe": false,
//         "isSent": true,
//         "formattedTime": Helpers.formatTimestamp(data["createdAt"]),
//         "id": data["_id"],
//         "type": data["type"] ?? "text",
//         "files": data["files"],
//       });
//     });
//   }
//
//   Future<void> fetchMessages({bool isPagination = false}) async {
//     if (isPagination && !hasMore) return;
//
//     if (isPagination) {
//       isPaginationLoading.value = true;
//     } else {
//       isLoading.value = true;
//     }
//
//     await ApiRequest.get(
//       fromJson: AllConversationModel.fromJson,
//       endPoint: '${ApiEndPoints.allMessage}/$roomId?page=1&limit=$limit',
//       isLoading: isLoading,
//       onSuccess: (result) {
//         final msgs = <Map<String, dynamic>>[];
//         for (var conversion in result.data.messages ?? []) {
//           msgs.add({
//             "message": conversion.message ?? '',
//             "isMe": conversion.isMe ?? false,
//             "isSent": true,
//             "formattedTime": Helpers.formatTimestamp(conversion.createdAt),
//             "id": conversion.id,
//             "type": conversion.type ?? "text",
//             "files": conversion.files,
//           });
//         }
//
//         if (isPagination) {
//           messagesList.insertAll(0, msgs);
//         } else {
//           messagesList.clear();
//           messagesList.addAll(msgs);
//         }
//
//         skip += msgs.length;
//         if (msgs.length < limit) hasMore = false;
//       },
//     );
//
//     isPaginationLoading.value = false;
//     isLoading.value = false;
//   }
//
//   Future<void> pickImageFromGallery() async {
//     try {
//       final image = await ImagePicker().pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );
//       if (image != null) selectedImage.value = image;
//     } catch (e) {
//       CustomSnackBar.error('Failed to pick image');
//     }
//   }
//
//   void removeImage() => selectedImage.value = null;
//
//   void sendMessage() {
//     final msg = textController.text.trim();
//     final hasImage = selectedImage.value != null;
//
//     if (msg.isEmpty && !hasImage) return;
//
//     if (hasImage) {
//       _sendImageWithText(msg);
//     } else {
//       // Add text locally for sender
//       final tempId = DateTime.now().millisecondsSinceEpoch.toString();
//       messagesList.add({
//         "id": tempId,
//         "message": msg,
//         "isMe": true,
//         "isSent": true,
//         "formattedTime": Helpers.formatTimestamp(DateTime.now().toString()),
//         "type": "text",
//       });
//
//       // Send via socket
//       socket.emit("message", {"receiver": receiverId, "message": msg});
//
//       textController.clear();
//     }
//   }
//
//   Future<void> _sendImageWithText(String message) async {
//     if (selectedImage.value == null) return;
//
//     final tempId = DateTime.now().millisecondsSinceEpoch.toString();
//     final localPath = selectedImage.value!.path;
//
//     // Add message + image bubble immediately
//     messagesList.add({
//       "id": tempId,
//       "isMe": true,
//       "type": "file",
//       "files": [localPath],
//       "message": message,
//       "isLoading": true,
//       "isSent": false,
//       "formattedTime": Helpers.formatTimestamp(DateTime.now().toString()),
//     });
//
//     selectedImage.value = null;
//     textController.clear();
//
//     try {
//       final result = await ApiRequest.multiMultipartRequest(
//         reqType: "POST",
//         fromJson: BasicSuccessModel.fromJson,
//         endPoint: ApiEndPoints.chats,
//         isLoading: RxBool(false),
//         files: {"files": File(localPath)},
//         body: {
//           "receiver": receiverId,
//           if (message.isNotEmpty) "message": message,
//         },
//         onSuccess: (res) {
//           final index = messagesList.indexWhere((m) => m["id"] == tempId);
//           if (index != -1) {
//             messagesList[index] = {
//               ...messagesList[index],
//               "isSent": true,
//               "isLoading": false,
//               "message": message,
//               "files": messagesList[index]["files"],
//             };
//             messagesList.refresh();
//           }
//
//           socket.emit("message", {
//             "receiver": receiverId,
//             "message": message,
//             "files": [localPath],
//             "type": "file",
//           });
//         },
//       );
//     } catch (e) {
//       messagesList.removeWhere((m) => m["id"] == tempId);
//       CustomSnackBar.error("Failed to send message");
//       log("Error sending image+text: $e");
//     }
//   }
//
//   @override
//   void onClose() {
//     socket.disconnect();
//     socket.dispose();
//     textController.dispose();
//     super.onClose();
//   }
// }
