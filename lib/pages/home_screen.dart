import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:loki/database.dart';
import 'package:loki/models/sound.dart';
import 'package:loki/pages/crud_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Sound> sounds = [];

  AudioPlayer audioPlayer = AudioPlayer();

  int current = -1;

  @override
  void initState() {
    DbHelper.getSounds().then((value) {
      sounds = value;
      setState(() {});
      return;
    });
    super.initState();
  }

  void playSound(Uint8List media, int index) async {
    await audioPlayer.playBytes(media);
    current = index;
    if (kDebugMode) {
      print('file is playing...');
    }
    setState(() {});
    return;
  }

  void deleteSound(Sound sound, BuildContext context) async {
    await DbHelper.deleteSoundById(sound.id!);
    sounds.remove(sound); 
    setState(() {});
    Navigator.pop(context);
    return;
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Listening To Animal Sounds!'),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            sounds.length,
            (index) => AnimalItem(
                sound: sounds[index],
                selected: current == index ? true : false,
                onTryDelete: () => deleteSound(sounds[index], context),
                onPressed: () => playSound(sounds[index].media, index)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return const CrudPage();
            }));
          },
          child: const Icon(Icons.add)),
    );
  }
}

class AnimalItem extends StatelessWidget {
  final Sound sound;
  final bool selected;
  final VoidCallback? onPressed;
  final VoidCallback? onTryDelete;
  const AnimalItem(
      {Key? key,
      this.selected = false,
      required this.sound,
      this.onPressed,
      this.onTryDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double w = size.width * 0.5;

    return GestureDetector(
        onTap: onPressed,
        onLongPress: () {
          Scaffold.of(context).showBottomSheet((ctx) {
            return GestureDetector(
              onTap: onTryDelete,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 100,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("DELETE ${sound.name.toUpperCase()}",
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    const Icon(Icons.delete, color: Colors.red)
                  ],
                ),
              ),
            );
          });
        },
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                width: w,
                height: w,
                clipBehavior: Clip.hardEdge,
                child: Image.memory(sound.image, fit: BoxFit.cover),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: selected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      width: 5),
                  color: Theme.of(context).primaryColor.withAlpha(100),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(sound.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor))
          ],
        ));
  }
}
