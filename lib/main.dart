import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'remove_duplicates.dart';

late File collectionXML;
List<String> userPhaseList = [
  "noFileLoaded",
  "fileLoaded",
  "duplicateFunctionality",
  "garbageFunctionality"
];
int activePhaseIndex = 0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RekordBoxFix App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekordbox Fix'),
      ),
      body: const Duplicates(),
    );
  }
}

class Duplicates extends StatefulWidget {
  const Duplicates({super.key});

  @override
  State<Duplicates> createState() => _DuplicatesState();
}

class _DuplicatesState extends State<Duplicates> {
  Future<FilePickerResult?> filepicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    // If a legit file is picked collectionXML updates to contain the filepath and the stateIndex is moved
    if (result != null) {
      String filePath = result.files.single.path ?? 'NoFileSelected';
      collectionXML = File(filePath);
      setState(() => {activePhaseIndex = 1});
    }
    return result;
  }
// TODO: So now the idea is to somehow update thet state whenever the buttons are pressed

  @override
  Widget build(BuildContext context) {
    switch (activePhaseIndex) {
      case 0:
        {
          return homeWithoutFile();
        }

      case 1:
        {
          return homeWithFile();
        }

      case 2:
        {
          return duplicatesMenu();
        }

      /* TODO: CREATE OTHER CASES
      case 3: 
      {
        return garbageMenu(context);
      }
      */
      default:
        {
          return homeWithoutFile();
        }
    }
  }

  Widget duplicatesMenu() {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('List of Duplicates'),
        ),
        body: ListView(
          children: [findDuplicates(collectionXML)],
        ),
      ),
    );
  }

  Widget homeWithFile() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              Icon(
                Icons.audio_file_outlined,
                color: Theme.of(context).primaryColor,
                size: 64,
              ),
              Text(collectionXML.path),
            ]),

            ElevatedButton(
                child: const Text('Find duplicates'),
                onPressed: () => {print('placeholder duplicatescript')}),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () => {
                setState(
                  () => {activePhaseIndex = 0},
                )
              },
            ) //Still need to find a way to get the filename here
          ],
        ),
      ),
    );
  }

  Widget homeWithoutFile() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Import your collection\'s XML'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                filepicker(); //
              },
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Import'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
