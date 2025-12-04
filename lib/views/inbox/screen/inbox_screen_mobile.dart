import '../../../core/utils/basic_import.dart';
import '../controller/inbox_controller.dart';

class InboxScreenMobile extends GetView<InboxController> {
  const InboxScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final participantName = args["name"] ?? "User";
    final participantEmail = args["email"];
    final profileImage = args["profileImage"];
    controller.connectToSocket();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: CustomColors.primary,
              backgroundImage: profileImage != null
                  ? NetworkImage("http://your-base-url/$profileImage")
                  : null,
              child: profileImage == null
                  ? Text(
                      participantName[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participantName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (participantEmail != null)
                  Text(
                    participantEmail,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,
                  reverse: true,
                  itemCount: controller.messageList.length,
                  itemBuilder: (context, index) {
                    final message = controller.messageList[index];

                    return Align(
                      alignment: message.isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: message.isMe
                              ? CustomColors.primary
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message.text ?? '',
                          style: TextStyle(
                            color: message.isMe ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.image,
                        color: CustomColors.primary,
                      ),
                      onPressed: () => controller.pickImageFromGallery(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.textController,
                        onChanged: (value) {
                          controller.hasTextOrImage.value = value
                              .trim()
                              .isNotEmpty;
                        },
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: CustomColors.primary),
                      onPressed: () => controller.sendMessage(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
