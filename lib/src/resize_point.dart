import 'package:flutter/material.dart';

import 'draggable_point.dart';
import 'draggable_resizable.dart';
import 'enums.dart';
import 'stickerview.dart';

const _cursorLookup = <ResizePointType, MouseCursor>{
  ResizePointType.topLeft: SystemMouseCursors.resizeUpLeft,
  ResizePointType.topRight: SystemMouseCursors.resizeUpRight,
  ResizePointType.bottomLeft: SystemMouseCursors.resizeDownLeft,
  ResizePointType.bottomRight: SystemMouseCursors.resizeDownRight,
};

class ResizePoint extends StatelessWidget {
  const ResizePoint({
    Key? key,
    required this.onDrag,
    required this.type,
    this.onScale,
    this.iconData,
  }) : super(key: key);

  final ValueSetter<Offset> onDrag;
  final ValueSetter<double>? onScale;
  final ResizePointType type;
  final IconData? iconData;

  MouseCursor get _cursor {
    return _cursorLookup[type]!;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _cursor,
      child: DraggablePoint(
        mode: PositionMode.local,
        onDrag: onDrag,
        onScale: onScale,
        child: Container(
          width: StickerView.cornerDiameter,
          height: StickerView.cornerDiameter,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: iconData != null
                ? Icon(
                    iconData,
                    size: 12,
                    color: Colors.blue,
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
