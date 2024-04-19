import 'package:flutter/material.dart';

/// 初始化类
class Sticker extends StatefulWidget {
  /// 元素组件
  final Widget? child;

  /// 是否自适应大小
  final bool isText;

  /// id
  final String id;

  /// 缩放
  final double scale;

  /// 旋转角度
  final double angle;

  /// 位置
  final Offset position;
  const Sticker({
    Key? key,
    this.child,
    this.isText = false,
    this.scale = 1,
    this.angle = 0,
    this.position = Offset.zero,
    required this.id,
  }) : super(key: key);
  @override
  _StickerState createState() => _StickerState();
}

class _StickerState extends State<Sticker> {
  @override
  Widget build(BuildContext context) {
    return widget.child != null ? widget.child! : Container();
  }
}
