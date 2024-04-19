# sticker_view

A Flutter plugin to rotate, resize, move, delete any text, image or any other widget.
<br>

## Available Features

✅ &nbsp; Resize</br>
✅ &nbsp; Move</br>
✅ &nbsp; Layer Update (Change Stack position)</br>
✅ &nbsp; Delete
<br>
<br>

## :rocket: Installation


#### Integrate sticker_view

```dart
 StickerView(
            // List of Stickers
            stickerList: [
              Sticker(
                child: const Text("Hello"),
                id: "uniqueId_111",
                isText: true,
                scale: 3,
                angle: 30,
                position: Offset(
                  100,
                  100,
                ),
              ),
              Sticker(
                child: const Text("Hello"),
                id: "uniqueId_222",
                isText: true,
              ),
            ],
          ),
```

#### Save StickerView as Uint8List

```dart
  // Give the Image Quality (High, Medium, Low)
  await StickerView.saveAsUint8List(ImageQuality.high);
```
