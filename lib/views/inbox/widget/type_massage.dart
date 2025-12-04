import 'package:doda_work/core/utils/extensions.dart';
import 'package:doda_work/views/inbox/controller/inbox_controller.dart';
import '../../../core/utils/basic_import.dart';

class TypeMessageWidget extends GetView<InboxController> {
  const TypeMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
      child: Row(
        children: [
          // 📸 Image picker
          InkWell(
            // onTap: controller.pickImageFromGallery,
            onTap: (){},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: SvgPicture.asset(
              Assets.icons.picture1,
              height: Dimensions.iconSizeLarge * 0.9,
            ),
          ),

          // 💬 Input field
          Expanded(
            child: Container(
              margin: Dimensions.defaultHorizontalSize.edgeHorizontal,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.widthSize,
                vertical: Dimensions.heightSize * 0.6,
              ),
              decoration: BoxDecoration(
                color: CustomColors.whiteColor,
                borderRadius: BorderRadius.circular(Dimensions.radius * 2.5),
                border: Border.all(
                  color: CustomColors.primary.withOpacity(0.35),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller.textController,
                cursorColor: CustomColors.primary,
                minLines: 1,
                maxLines: 3,
                style: TextStyle(
                  fontSize: Dimensions.titleSmall * 0.92,
                  fontWeight: FontWeight.w400,
                  color: CustomColors.blackColor,
                ),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(
                    color: CustomColors.grayShade.withOpacity(0.65),
                    fontSize: Dimensions.titleSmall * 0.88,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // 📤 Send button (Reactive)
          Obx(() {
            final active = controller.hasText.value;
            return GestureDetector(
              onTap: active ? controller.sendMessage : null,
              child: Container(
                height: Dimensions.inputBoxHeight * 0.55,
                width: Dimensions.inputBoxHeight * 0.55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? CustomColors.primary
                      : CustomColors.grayShade.withOpacity(0.4),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: CustomColors.primary.withOpacity(0.35),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  Icons.send_rounded,
                  size: Dimensions.iconSizeSmall * 1.5,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
