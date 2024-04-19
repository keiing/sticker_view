import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sticker_view/sticker_view.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Sticker> stickers = const [
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
      child: SizedBox(
        child: Text(
          "HelloHeHelloHeHelloHeHelloHeHelloHeHelloHeHelloHeHelloHeHelloHeHelloHe",
          style: TextStyle(
            fontSize: 20,
          ),
          softWrap: false,
        ),
      ),

      scale: 3,

      position: Offset(
        100,
        100,
      ),
      // isText: true,
      id: "uniqueId_222",
    ),
    Sticker(
      child: SizedBox(
        child: Text(
          "HelloHeHelloHeHelloHeHelloHeHelloHe",
          style: TextStyle(
            fontSize: 20,
          ),
          softWrap: false,
        ),
      ),
      // isText: true,
      id: "uniqueId_333",
    ),
  ];

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save_alt),
          onPressed: () async {
            // Uint8List? imageData =
            //     await StickerView.saveAsUint8List(ImageQuality.high);
            // if (imageData != null) {
            //   var imageName = DateTime.now().microsecondsSinceEpoch.toString();
            //   var appDocDir = await getApplicationDocumentsDirectory();
            //   // String imagePath = appDocDir.path + imageName + '.png';
            //   // File imageFile = File(imagePath);
            //   // imageFile.writeAsBytesSync(imageData);
            //   // // ignore: avoid_print
            //   // print("imageFile::::$imageFile");
            // }

            // final render = key1.currentContext?.findRenderObject() as RenderBox;
            // print(render.size);
            // print(render.paintBounds);
            // print(render);

            print(stickGlobalKey.currentState);
          },
        ),
        body: Row(
          // Sticker Editor View
          children: [
            Expanded(
              child: StickerView(
                // List of Stickers
                // width: 500,
                stickerList: stickers,
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: TextField(
                controller: textController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
