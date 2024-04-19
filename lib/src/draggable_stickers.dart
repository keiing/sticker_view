import 'package:flutter/material.dart';
import 'draggable_resizable.dart';
import 'sticker.dart';

class DraggableStickers extends StatefulWidget {
  //List of stickers (elements)
  final List<Sticker>? stickerList;

  final double width;

  // ignore: use_key_in_widget_constructors
  const DraggableStickers({
    this.stickerList,
    required this.width,
  });

  @override
  State<DraggableStickers> createState() => _DraggableStickersState();
}

class _DraggableStickersState extends State<DraggableStickers> {
  List<Sticker> stickers = [];

  /// 当前选中
  String? selectedAssetId;

  @override
  void initState() {
    setState(() {
      stickers = widget.stickerList ?? [];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return stickers.isNotEmpty && stickers != []
        ? Stack(
            fit: StackFit.expand,
            children: [
              /// 拦截点击事件
              Positioned.fill(
                child: GestureDetector(
                  key: const Key('stickersView_background_gestureDetector'),
                  onTap: () {
                    print(
                      'stickersView_background_gestureDetector -> tap',
                    );
                  },
                ),
              ),
              for (final sticker in stickers)

                // Main widget that handles all features like rotate, resize, edit, delete, layer update etc.
                DraggableResizable(
                  key:
                      Key('stickerPage_${sticker.id}_draggableResizable_asset'),
                  canTransform: selectedAssetId == sticker.id ? true : false

                  //  true
                  /*sticker.id == state.selectedAssetId*/,

                  sticker: sticker,

                  onUpdate: (update) {
                    print(
                      update,
                    );
                    if (selectedAssetId != sticker.id) {
                      setState(() {
                        selectedAssetId = sticker.id;
                      });
                    }
                  },

                  onLayerTapped: () {
                    var listLength = stickers.length;
                    var ind = stickers.indexOf(sticker);
                    stickers.remove(sticker);
                    if (ind == listLength - 1) {
                      stickers.insert(0, sticker);
                    } else {
                      stickers.insert(listLength - 1, sticker);
                    }

                    selectedAssetId = sticker.id;
                    setState(() {});
                  },

                  // 编辑事件
                  onEdit: () {},

                  // To Delete the sticker
                  onDelete: () async {
                    {
                      stickers.remove(sticker);
                      setState(() {});
                    }
                  },

                  // Child widget in which sticker is passed
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      selectedAssetId = sticker.id;
                      setState(() {});
                    },
                    child: sticker,
                  ),
                ),
            ],
          )
        : Container();
  }
}
