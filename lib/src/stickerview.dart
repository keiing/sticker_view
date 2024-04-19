import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'draggable_resizable.dart';
import 'draggable_stickers.dart';
import 'sticker.dart';

enum ImageQuality { low, medium, high }

///
/// StickerView
/// A Flutter widget that can rotate, resize, edit and manage layers of widgets.
/// You can pass any widget to it as Sticker's child
///
class StickerView extends StatefulWidget {
  final List<Sticker>? stickerList;
  final double? height; // height of the editor view
  final double? width; // width of the editor view

  // ignore: use_key_in_widget_constructors
  const StickerView({
    this.stickerList,
    this.height,
    this.width,
  });

  /// 纵向间距
  static const cornerDiameter = 5.0;

  /// 横向间距
  static const floatingActionDiameter = 20.0;
  static const floatingActionPadding = 0.0;

  /// 保存为 unit8list 图片数据
  // Method for saving image of the editor view as Uint8List
  // You have to pass the imageQuality as per your requirement (ImageQuality.low, ImageQuality.medium or ImageQuality.high)
  static Future<Uint8List?> saveAsUint8List(ImageQuality imageQuality) async {
    try {
      Uint8List? pngBytes;
      double pixelRatio = 1;
      if (imageQuality == ImageQuality.high) {
        pixelRatio = 2;
      } else if (imageQuality == ImageQuality.low) {
        pixelRatio = 0.5;
      }
      // delayed by few seconds because it takes some time to update the state by RenderRepaintBoundary
      await Future.delayed(const Duration(milliseconds: 700)).then(
        (value) async {
          RenderRepaintBoundary boundary = stickGlobalKey.currentContext
              ?.findRenderObject() as RenderRepaintBoundary;
          ui.Image image = await boundary.toImage(
            pixelRatio: pixelRatio,
          );
          ByteData? byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );
          pngBytes = byteData?.buffer.asUint8List();
        },
      );
      // returns Uint8List
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  @override
  StickerViewState createState() => StickerViewState();
}

//GlobalKey is defined for capturing screenshot
final GlobalKey stickGlobalKey = GlobalKey();

class StickerViewState extends State<StickerView> {
  // You have to pass the List of Sticker
  late List<Sticker> stickers;

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
    return Column(
      children: [
        //For capturing screenshot of the widget
        RepaintBoundary(
          key: stickGlobalKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            height: widget.height ?? MediaQuery.of(context).size.height,
            width: widget.width ?? MediaQuery.of(context).size.width,
            child: Stack(
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
                    key: Key(
                      'stickerPage_${sticker.id}_draggableResizable_asset',
                    ),
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
                    child: sticker,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
