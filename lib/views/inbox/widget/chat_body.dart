// import 'dart:io';
// import '../../../core/utils/basic_import.dart';
// import '../controller/inbox_controller.dart';
//
// class ChatBodyWidget extends GetView<InboxController> {
//   const ChatBodyWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isRtl = Directionality.of(context) == TextDirection.rtl;
//     final mq = MediaQuery.of(context);
//
//     return Obx(() {
//       if (controller.messageList.isEmpty) {
//         return Center(
//           child: TextWidget(
//             "No messages yet",
//             fontSize: mq.size.width * 0.04,
//             color: CustomColors.grayShade,
//           ),
//         );
//       }
//
//       // Animate scroll to bottom when new message arrives
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (controller.scrollController.hasClients) {
//           controller.scrollController.animateTo(
//             0.0,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOutQuart,
//           );
//         }
//       });
//
//       return ListView.builder(
//         controller: controller.scrollController,
//         reverse: true,
//         physics: const BouncingScrollPhysics(
//           parent: AlwaysScrollableScrollPhysics(),
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: mq.size.width * 0.04,
//           vertical: mq.size.height * 0.02,
//         ),
//         itemCount: controller.messageList.length,
//         itemBuilder: (context, index) {
//           final message =
//               controller.messageList[controller.messageList.length - 1 - index];
//           final isMe = message.isMe;
//
//           final messageWidget = Container(
//             margin: EdgeInsets.symmetric(
//               vertical: Dimensions.verticalSize * 0.2,
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             constraints: BoxConstraints(maxWidth: mq.size.width * 0.7),
//             decoration: BoxDecoration(
//               color: isMe ? CustomColors.whiteColor : Colors.grey.shade200,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(Dimensions.radius * (isMe ? 0.85 : 1)),
//                 topRight: Radius.circular(
//                   Dimensions.radius * (isMe ? 0.85 : 1),
//                 ),
//                 bottomLeft: Radius.circular(
//                   Dimensions.radius * (isMe ? 0.85 : 1),
//                 ),
//                 bottomRight: Radius.circular(
//                   Dimensions.radius * (isMe ? 1 : 0.85),
//                 ),
//               ),
//             ),
//             child: message.imageUrl != null
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(
//                       Dimensions.radius * 0.85,
//                     ),
//                     child: Image.file(
//                       File(message.imageUrl!),
//                       width: mq.size.width * 0.5,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                 : TextWidget(
//                     message.text ?? '',
//                     fontSize: mq.size.width * 0.04,
//                     color: isMe ? Colors.white : Colors.black,
//                   ),
//           );
//
//           final timeWidget = Padding(
//             padding: const EdgeInsets.only(top: 4),
//             child: TextWidget(
//               message.time ?? '12:00',
//               fontSize: Dimensions.titleSmall * 0.7,
//               color: CustomColors.grayShade,
//             ),
//           );
//
//           if (isMe) {
//             return Align(
//               alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
//               child: Column(
//                 crossAxisAlignment: isRtl
//                     ? CrossAxisAlignment.start
//                     : CrossAxisAlignment.end,
//                 children: [messageWidget, timeWidget],
//               ),
//             );
//           } else {
//             return Align(
//               alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: Stack(
//                       children: [
//                         CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Colors.grey.shade300,
//                           child: ClipOval(
//                             child: CachedNetworkImage(
//                               imageUrl:
//                                   'https://t4.ftcdn.net/jpg/04/31/64/75/360_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.jpg',
//                               fit: BoxFit.cover,
//                               width: 40,
//                               height: 40,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: Icon(
//                             Icons.circle,
//                             color: Colors.green,
//                             size: Dimensions.iconSizeSmall,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextWidget(
//                         'Stevano Clirover',
//                         fontWeight: FontWeight.w600,
//                         fontSize: Dimensions.titleSmall * 0.9,
//                       ),
//                       messageWidget,
//                       timeWidget,
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       );
//     });
//   }
// }
