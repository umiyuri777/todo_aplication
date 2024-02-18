

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp()
    )
  );
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
      home:  const MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref){
    // final todo = useState<List<String>>([]);
    // final TextEditingController _controller = useTextEditingController();
    final todolist = ref.watch(todolistProvider);
    // final tabController = useTabController(initialLength: 2);
    
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Todoリスト'),
            backgroundColor: Colors.blue,
            //tabbarを設定
            bottom: const TabBar(
              tabs: [
                Tab(text: "未完了", icon: Icon(Icons.star),),
                Tab(text: "完了済", icon: Icon(Icons.done),)
              ],  
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewNoteCreate()),
              ).then((value) {
                ref.read(todolistProvider.notifier).add(value);
              });
            },
            child: const Icon(Icons.add)  //追加ボタン
          ),
          body: TabBarView(
            children: [
              _buildListView(todolist, ref),
              const Center(
                child: Text(
                'mikanのタスク', 
                style: TextStyle(fontSize: 20))
              ),
            ]
          )
        ),
      ),
    );
  }
}

Widget _buildListView(todolist, WidgetRef ref){
  return  ListView.builder(
    shrinkWrap: true,
    itemCount: todolist.length,
    itemBuilder: (context, index){
      return Card(
        child: ListTile(
          title: Text(todolist[index]),
          trailing: IconButton(
            onPressed: () {
              ref.read(todolistProvider.notifier).remove(todolist[index]);
            },
            icon: const Icon(Icons.delete)
          ),
        )
      );
    }
  );
}

class NewNoteCreate extends HookConsumerWidget {
  const NewNoteCreate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _controller = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('新しいメモ'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'メモ',
              hintText: '新しいメモを入力してください',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _controller.text);
            },
            child: const Text('追加'),
          ),
        ],
      )
    );
  }
}

final todolistProvider = StateNotifierProvider<TodoListNotifier, List<String>>((ref) => TodoListNotifier(),);

class TodoListNotifier extends StateNotifier<List<String>>{
  TodoListNotifier() : super([]);

  void add(String todo){
    state = [...state, todo];
  }

  void remove(String todo){
    state = [
      for(final item in state)
        if(item != todo) item,
    ];
  }
}

