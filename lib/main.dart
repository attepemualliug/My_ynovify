import 'package:flutter/material.dart';
import 'package:my_ynovify/music.dart';
import 'package:just_audio/just_audio.dart';

const Color principal = Color.fromARGB(255, 66, 255, 0);
const Color secondary = Colors.white;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ynovify',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color.fromARGB(255, 33, 33, 33),
      ),
      home: const MyHomePage(title: 'Ynovify'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
// double _currentSliderValue = duration;

//   @override
//   Widget build(BuildContext context) {
//     return Slider(
//       value: _currentSliderValue,
//       max: 100,
//       divisions: duration,
//       label: _currentSliderValue.round().toString(),
//       onChanged: (double value) {
//         setState(() {
//           _currentSliderValue = value;
//         });
//       },
//     );
//   }

class _MyHomePageState extends State<MyHomePage> {
  bool selected = true;
  int music = 0;
  String duration = "";

  List<Music> musicList = [
    Music(
        'Civilisation',
        'Orelsan',
        'assets/img/Windmill.jpg',
        'https://codiceo.fr/mp3/civilisation.mp3'),
    Music(
        'A state of Trance',
        'Armin',
        'assets/img/Land.jpg',
        'https://codiceo.fr/mp3/armin.mp3')
  ];
  final _player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _init(music);
  }

  void _afterThisMusicCounter() {
    setState(() {
      (music == musicList.length - 1) ? music = 0 : music++;
    });
    _init(music);
  }

  void _beforeThisMusicCounter() {
    setState(() {
      (music == 0) ? music = musicList.length - 1 : music--;
    });
    _init(music);
  }

  Future<void> _init(int music) async {
    await _player
        .setAudioSource(
            AudioSource.uri(Uri.parse(musicList[music].urlSong)))
        .then((value) => {
              setState(() {
                duration = "${value!.inMinutes}:${value.inSeconds % 100}";
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(50),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: secondary, width: 1),
                  ),
                  child: Image.asset(musicList[music].imagePath),
                )
                ),
            Text(
              musicList[music].title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: secondary,
              ),
            ),
            Text(
              musicList[music].singer,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                duration,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: secondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      color: principal,
                      icon: const Icon(Icons.fast_rewind),
                      onPressed: _beforeThisMusicCounter,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      color: principal,
                      icon: Icon(selected ? Icons.play_arrow : Icons.pause),
                      onPressed: () {
                        setState(() {
                          selected = !selected;
                          (selected ? _player.pause() : _player.play());
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      color: principal,
                      icon: const Icon(Icons.fast_forward),
                      onPressed: _afterThisMusicCounter,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
