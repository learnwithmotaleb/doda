import '../../../core/utils/app_storage.dart';
import '../../../core/utils/basic_import.dart';
import '../../../core/utils/extensions.dart';
import '../../../routes/routes.dart';
import '../../navigation/controller/navigation_controller.dart';
import '../controller/chat_controller.dart';

class ChatScreenMobile extends StatelessWidget {
  ChatScreenMobile({super.key});

  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    final myId = AppStorage.userId;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: Dimensions.appBarHeight * 1.6,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.defaultHorizontalSize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.find<NavigationController>().goToProfile(),
                  child: SvgPicture.asset(Assets.logo.appLogo, height: 45),
                ),
                TextWidget(
                  'Chat',
                  color: CustomColors.blackColor,
                  fontSize: Dimensions.titleMedium * 1.2,
                  fontWeight: FontWeight.w600,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.notificationScreen),
                  child: Container(
                    margin: Dimensions.defaultHorizontalSize.edgeRight,
                    padding: EdgeInsets.all(Dimensions.paddingSize * 0.35),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.primary),
                    ),
                    child: SvgPicture.asset(Assets.icons.group),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: CustomColors.primary),
            );
          }

          /// 🔥 FILTER: Hide chats where only I am the participant
          final filteredChats = controller.chatList.where((chat) {
            final others = controller
                .getAllParticipants(chat)
                .where((p) => p.id != myId)
                .toList();
            return others.isNotEmpty; // Only show chats with other users
          }).toList();

          if (filteredChats.isEmpty) {
            return const Center(child: Text("No participants yet"));
          }

          return ListView.builder(
            itemCount: filteredChats.length,
            itemBuilder: (context, index) {
              final chat = filteredChats[index];

              /// Find participants except myself
              final participants = controller
                  .getAllParticipants(chat)
                  .where((p) => p.id != myId)
                  .toList();

              if (participants.isEmpty) return const SizedBox.shrink();

              // For 1-to-1 chat, take the last participant
              final participant = participants.last;

              return ListTile(
                onTap: () => controller.openConversation(chat, participant),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: CustomColors.primary,
                  backgroundImage: participant.profileImage != null
                      ? NetworkImage("http://your-base-url/${participant.profileImage}")
                      : null,
                  child: participant.profileImage == null
                      ? Text(
                    participant.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                      : null,
                ),
                title: Text(participant.name),
                subtitle: Text(participant.email ?? ""),
              );
            },
          );
        }),
      ),
    );
  }
}
