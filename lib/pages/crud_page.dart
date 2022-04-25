import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loki/database.dart';
import 'package:loki/models/sound.dart';
import 'package:loki/pages/home_screen.dart';

enum ActionType { addPoster, addSound }

class ActionItem {
  String label;
  ActionType action;
  ActionItem({required this.label, required this.action});
}

final actions = [
  ActionItem(label: "Add Poster", action: ActionType.addPoster),
  ActionItem(label: "Add Sound", action: ActionType.addSound)
];

class CrudPage extends StatefulWidget {
  const CrudPage({Key? key}) : super(key: key);

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  String name = "";
  Uint8List? media;
  Uint8List? image;

  void onSelected(ActionItem actionItem) async {
    switch (actionItem.action) {
      case ActionType.addPoster:
        var result = await FilePicker.platform.pickFiles(
            type: FileType.custom, allowedExtensions: ['png', 'jpg', 'webp']);
        if (result != null) {
          image = await File(result.files.single.path!).readAsBytes();
          setState(() {});
          return;
        }
        break;
      case ActionType.addSound:
        var result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);
        if (result != null) {
          media = await File(result.files.single.path!).readAsBytes();
          setState(() {});
          return;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Sound'),
        actions: [
          PopupMenuButton<ActionItem>(
              onSelected: onSelected,
              itemBuilder: (ctx) {
                return actions
                    .map((action) => PopupMenuItem<ActionItem>(
                        value: action, child: Text(action.label)))
                    .toList();
              })
        ],
      ),
      body: Form(
          child: SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            clipBehavior: Clip.hardEdge,
                            child: image == null
                                ? const Icon(Icons.photo)
                                : Image.memory(image!, fit: BoxFit.cover),
                            decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                          ),
                          const SizedBox(width: 15),
                          media != null
                              ? Container(
                                  height: 90,
                                  width: 90,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.music_note),
                                  decoration: const BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))),
                                )
                              : Container()
                        ],
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Name'),
                        onChanged: (val) => name = val,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        child: ElevatedButton(
                            onPressed: () async {
                              if (media != null &&
                                  image != null &&
                                  name.isNotEmpty) {
                                var sound = Sound(
                                    name: name, media: media!, image: image!);
                                await DbHelper.database
                                    ?.insert("Sound", sound.toMap());
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const HomeScreen()),(r)=> false);
                                print('sound was inserted!');
                              }
                            },
                            child: const Text('Add Sound')),
                        width: double.maxFinite,
                      )
                    ],
                  )))),
    );
  }
}
