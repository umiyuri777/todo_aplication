

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: const MyApp()
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
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref){
    // final todo = useState<List<String>>([]);
    final TextEditingController _controller = useTextEditingController();
    final todolist = ref.watch(todolistProvider);
    final tabController = useTabController(initialLength: 2);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoリスト'),
        backgroundColor: Colors.blue,
        //tabbarを設定
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "未完了",),
            Tab(text: "完了済",)
          ],  
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'タスクを入力してください',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(todolistProvider.notifier).add(_controller.value.text);
            }, 
            child: const Text('追加')
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: todolist.length,
            itemBuilder: (context, index){
              // final item = todolist[index];
              return Card(
                child: ListTile(
                  title: Text('${todolist[index]}'),
                  trailing: IconButton(
                    onPressed: () {
                      ref.read(todolistProvider.notifier).remove(todolist[index]);
                    },
                    icon: Icon(Icons.delete)
                  ),

                )
              );
            }
          )
        ],
      ),
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



