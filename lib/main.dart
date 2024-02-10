

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final _text = useState<String>('');
    return Scaffold(
      appBar: AppBar(title: const Text('Todoリスト'),
      backgroundColor: Colors.blue,),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text('helloworld!!!!')),
          
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'タスクを入力してください',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _text.value = _controller.value.text;
            }, 
            child: const Text('追加')
          ),
          Text(_text.value)
        ],
      ),
    );
  }
}

