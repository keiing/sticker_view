import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'draggable_point.dart';
import 'sticker.dart';
import 'stickerview.dart';

/// {@template drag_update}
/// Drag update model which includes the position and size.
/// {@endtemplate}
class DragUpdate {
  /// {@macro drag_update}
  const DragUpdate({
    required this.angle,
    required this.position,
    required this.size,
    required this.constraints,
  });

  /// The angle of the draggable asset.
  final double angle;

  /// The position of the draggable asset.
  final Offset position;

  /// The size of the draggable asset.
  final Size size;

  /// The constraints of the parent view.
  final Size constraints;
}

/// {@template draggable_resizable}
/// A widget which allows a user to drag and resize the provided [child].
/// {@endtemplate}
class DraggableResizable extends StatefulWidget {
  /// {@macro draggable_resizable}
  DraggableResizable({
    Key? key,
    required this.child,
    required this.sticker,

    // required this.size,
    BoxConstraints? constraints,
    this.onUpdate,
    this.onLayerTapped,
    this.onEdit,
    this.onDelete,
    this.canTransform = false,
  })  : constraints = constraints ?? BoxConstraints.loose(Size.infinite),
        super(key: key);

  /// The child which will be draggable/resizable.
  final Widget child;

  // final VoidCallback? onTap;

  /// Drag/Resize value setter.
  final ValueSetter<DragUpdate>? onUpdate;

  /// Delete callback
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onLayerTapped;

  /// Whether or not the asset can be dragged or resized.
  /// Defaults to false.
  final bool canTransform;

  /// The child's original size.
  // final Size size;

  /// The child's constraints.
  /// Defaults to [BoxConstraints.loose(Size.infinite)].
  final BoxConstraints constraints;
  final Sticker sticker;

  @override
  DraggableResizableState createState() => DraggableResizableState();
}

class DraggableResizableState extends State<DraggableResizable> {
  int type = 0;
  late Size size;
  late BoxConstraints constraints;

  /// 缩放
  late double scale;

  /// 初始缩放
  late double baseScale;

  /// 旋转
  late double angle;
  late double angleDelta;
  late double baseAngle;

  /// 子级是否已经通知父级
  bool isChildDispatch = false;

  bool get isTouchInputSupported => true;

  /// 初始位置
  late Offset position;

  ScaleStartDetails initDetails = ScaleStartDetails();
  Offset initPoint = ScaleStartDetails().focalPoint;

  @override
  void initState() {
    super.initState();
    size = Size.zero;
    constraints = widget.constraints;
    scale = widget.sticker.scale;
    baseScale = widget.sticker.scale;
    angle = widget.sticker.angle;
    baseAngle = widget.sticker.angle;
    angleDelta = widget.sticker.angle;
    position = widget.sticker.position;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /// 通知父级
  void onUpdate() {
    final normalizedLeft = position.dx;
    final normalizedTop = position.dy;

    final normalizedPosition = Offset(
      normalizedLeft +
          (StickerView.floatingActionPadding / 2) +
          (StickerView.cornerDiameter / 2),
      normalizedTop +
          (StickerView.floatingActionPadding / 2) +
          (StickerView.cornerDiameter / 2),
    );
    widget.onUpdate?.call(
      DragUpdate(
        position: normalizedPosition,
        size: size,
        constraints: Size(
          constraints.maxWidth,
          constraints.maxHeight,
        ),
        angle: angle,
      ),
    );
  }

  Widget getBuildecoratedChild() {
    final normalizedWidth = size.width;
    final normalizedHeight = size.height;

    /// 删除
    final deleteButton = _FloatingActionIcon(
      key: const Key('draggableResizable_delete_floatingActionIcon'),
      iconData: Icons.delete,
      onTap: widget.onDelete,
    );

    /// 图层
    final topCenter = _FloatingActionIcon(
      key: const Key('draggableResizable_layer_floatingActionIcon'),
      iconData: Icons.layers,
      onTap: widget.onLayerTapped,
    );

    /// 缩放
    final scanleAnchor = GestureDetector(
      key: const Key('draggableResizable_rotate_gestureDetector'),
      onScaleStart: (details) {
        // final offsetFromCenter = details.localFocalPoint - center;
        // setState(
        //   () => angleDelta = baseAngle -
        //       offsetFromCenter.direction -
        //       StickerView.floatingActionDiameter,
        // );
        baseScale = scale;
        initDetails = details;
        initPoint = details.focalPoint;
      },
      onScaleUpdate: (details) {
        final offsetFromCenter = details;
        final v =
            (offsetFromCenter.focalPoint.dx + offsetFromCenter.focalPoint.dy) /
                (initDetails.focalPoint.dx + initDetails.focalPoint.dy);

        print(v);

        setState(
          () {
            scale = baseScale + v - 1;
          },
        );

        // final offsetFromCenter = details.localFocalPoint - center;
        // final v = (offsetFromCenter.dx + offsetFromCenter.dy) /
        //     (initDetails.focalPoint.dx + initDetails.focalPoint.dy);
        // setState(
        //   () {
        //     scale = _scale + v;
        //   },
        // );
        // initPoint = details.focalPoint;
        print(baseScale);
        print(scale);
        onUpdate();
      },
      onScaleEnd: (_) {},
      child: _FloatingActionIcon(
        key: const Key('draggableResizable_rotate_floatingActionIcon'),
        iconData: Icons.document_scanner_rounded,
        onTap: () {},
      ),
    );

    return SizedBox(
      key: const Key('draggableResizable_child_container'),
      height: !isChildDispatch
          ? null
          : math.max(
              StickerView.cornerDiameter + StickerView.floatingActionPadding,
              normalizedHeight,
            ),
      width: !isChildDispatch
          ? null
          : math.max(
              StickerView.cornerDiameter + StickerView.floatingActionPadding,
              normalizedWidth,
            ),
      child: Stack(
        children: [
          widget.child,
          if (widget.canTransform && isTouchInputSupported) ...[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color:
                        widget.canTransform ? Colors.blue : Colors.transparent,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: StickerView.floatingActionPadding / 2,
              right: (normalizedWidth / 2) -
                  (StickerView.floatingActionDiameter / 2),
              child: Transform.scale(
                alignment: Alignment.topCenter,
                scale: (1 / scale),
                child: topCenter,
              ),
            ),
            Positioned(
              bottom: StickerView.floatingActionPadding / 2,
              left: StickerView.floatingActionPadding / 2,
              child: Transform.scale(
                alignment: Alignment.bottomLeft,
                scale: (1 / scale),
                child: deleteButton,
              ),
            ),
            Positioned(
              bottom: StickerView.floatingActionPadding / 2,
              right: StickerView.floatingActionPadding / 2,
              child: Transform.scale(
                alignment: Alignment.bottomRight,
                scale: (1 / scale),
                child: scanleAnchor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final normalizedLeft = position.dx;
    final normalizedTop = position.dy;

    return Stack(
      children: <Widget>[
        Positioned(
          top: normalizedTop,
          left: normalizedLeft,
          // height: !isChildDispatch ? null : normalizedHeight,
          // width: !isChildDispatch ? null : normalizedWidth,
          child: Transform(
            alignment: Alignment.topLeft,
            transform: Matrix4.identity()

              /// 缩放大小
              ..scale(
                scale,
              )

              /// 旋转角度
              ..rotateZ(
                angle,
              ),
            child: DraggablePoint(
              scale: scale,
              angle: angle,
              // mode: _PositionMode.global,
              key: const Key('draggableResizable_child_draggablePoint'),
              onSize: (Size size) {
                setState(
                  () {
                    this.size = size;
                    isChildDispatch = true;
                  },
                );
              },
              onTap: () {
                onUpdate();
              },
              onDrag: (d) {
                setState(
                  () {
                    position = Offset(
                      position.dx + d.dx,
                      position.dy + d.dy,
                    );
                  },
                );
                onUpdate();
              },
              onScale: (s) {
                scale = baseScale + s - baseScale ~/ 1;
              },
              child: getBuildecoratedChild(),
            ),
          ),
        ),
      ],
    );
  }
}

enum ResizePointType {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class _FloatingActionIcon extends StatelessWidget {
  const _FloatingActionIcon({
    Key? key,
    required this.iconData,
    this.onTap,
  }) : super(key: key);

  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: StickerView.floatingActionDiameter,
          width: StickerView.floatingActionDiameter,
          child: Center(
            child: Icon(
              iconData,
              color: Colors.blue,
              size: 12,
            ),
          ),
        ),
      ),
    );
  }
}
