import 'package:flutter/material.dart';

import 'draggable_resizable.dart';
import 'enums.dart';

class DraggablePoint extends StatefulWidget {
  const DraggablePoint({
    Key? key,
    required this.child,
    this.onDrag,
    this.onScale,
    this.onTap,
    this.onSize,
    this.angle = 0,
    this.scale = 1,
    this.mode = PositionMode.global,
  }) : super(key: key);

  final Widget child;
  final PositionMode mode;
  final ValueSetter<Offset>? onDrag;
  final ValueSetter<Size>? onSize;
  final ValueSetter<double>? onScale;
  final VoidCallback? onTap;

  /// 旋转角度
  final double angle;

  /// 缩放
  final double scale;

  @override
  DraggablePointState createState() => DraggablePointState();
}

class DraggablePointState extends State<DraggablePoint> {
  late Offset initPoint;
  var baseScale = 1.0;
  var baseAngle = 0.0;
  var angle = 0.0;
  var scale = 1.0;

  @override
  void initState() {
    super.initState();

    /// 设置选中角度
    angle = widget.angle;
    scale = widget.scale;
  }

  void dispatchParent() {
    final resize = context.findAncestorStateOfType<DraggableResizableState>();

    if (resize == null || resize.isChildDispatch == true) {
      return;
    }

    /// 异步执行
    Future(
      () {
        if (context.findRenderObject() == null) {
          return dispatchParent();
        }

        if (resize.isChildDispatch == true) {
          return;
        }

        final info = context.findRenderObject() as RenderBox;
        widget.onSize?.call(
          info.size,
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dispatchParent();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onScaleStart: (details) {
        switch (widget.mode) {
          case PositionMode.global:
            initPoint = details.focalPoint;
            break;
          case PositionMode.local:
            initPoint = details.localFocalPoint;
            break;
        }
        if (details.pointerCount > 1) {
          /// 初始旋转角度
          // baseAngle = angle;
          /// 设置缩放
          baseScale = scale;
          widget.onScale?.call(baseScale);
        }
      },
      onScaleUpdate: (details) {
        switch (widget.mode) {
          case PositionMode.global:
            final dx = details.focalPoint.dx - initPoint.dx;
            final dy = details.focalPoint.dy - initPoint.dy;
            initPoint = details.focalPoint;
            widget.onDrag?.call(
              Offset(
                dx,
                dy,
              ),
            );
            break;
          case PositionMode.local:
            final dx = details.localFocalPoint.dx - initPoint.dx;
            final dy = details.localFocalPoint.dy - initPoint.dy;
            initPoint = details.localFocalPoint;
            widget.onDrag?.call(
              Offset(
                dx,
                dy,
              ),
            );
            break;
        }

        if (

            /// 手指触摸大于1
            details.pointerCount > 1 ||

                /// 进行缩放

                details.scale != 1) {
          /// 缩放倍率
          scale = baseScale * details.scale;
          widget.onScale?.call(scale);
        }
      },
      child: widget.child,
    );
  }
}
