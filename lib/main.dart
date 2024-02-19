

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
    final todolist = ref.watch(todolistProvider);
    
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
              incompleted_buildListView(todolist, ref),
              completed_buildListView(todolist, ref)
            ]
          )
        ),
      ),
    );
  }
}

Widget incompleted_buildListView(todolist, WidgetRef ref){

  final incompletedtask = ref.watch(todolistProvider.notifier).incompletedtask;

  return  ListView.builder(
    shrinkWrap: true,
    itemCount: incompletedtask.length,
    itemBuilder: (context, index){
      return Card(
        child: ListTile(
          title: Text(incompletedtask[index].decoration),
          trailing: IconButton(
            onPressed: () {
              ref.read(todolistProvider.notifier).taskComplete(todolist[index]);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('完了済みに移動しました'))
              );
            },
            icon: const Icon(Icons.check_outlined)
          ),
        )
      );
    }
  );
}

Widget completed_buildListView(todolist, WidgetRef ref){

  final completetask = ref.watch(todolistProvider.notifier).completetask;

  return  ListView.builder(
    shrinkWrap: true,
    itemCount: completetask.length,
    itemBuilder: (context, index){
      return Card(
        child: ListTile(
          title: Text(completetask[index].decoration),
          trailing: IconButton(
            onPressed: () {
              ref.read(todolistProvider.notifier).remove(completetask[index]);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('削除しました'))
              );
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

class FilterType {
  final String decoration;
  bool isCompleted;

  FilterType({required this.decoration, this.isCompleted = false});
}

final todolistProvider = StateNotifierProvider<TodoListNotifier, List<FilterType>>((ref) => TodoListNotifier(),);

class TodoListNotifier extends StateNotifier<List<FilterType>>{
  TodoListNotifier() : super([]);

  void add(String todo){
    final add_item = FilterType(decoration: todo);
    state = [...state, add_item];
  }

  void taskComplete(FilterType todo){
    state = [
      for(final item in state)
        if(item == todo) item..isCompleted = true
        else item,
    ];
  }

  void remove(FilterType todo){
    state = [
      for(final item in state)
        if(item != todo) item,
    ];
  }

  List<FilterType> get completetask{
    return state.where((todo) => todo.isCompleted).toList();
  }

  List<FilterType> get incompletedtask{
    return state.where((todo) => !todo.isCompleted).toList();
  }
}

