import 'package:flutter/material.dart';
import 'package:mynotes/db/db_helper.dart';
import 'package:mynotes/model/model.dart';
import 'package:mynotes/ui/detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> _data = [];

  bool isOpen = false;

  void _getData() async {
    final data = await SqlHelper.getAllNotes();
    setState(() {
      _data = data;
    });
  }

  void _deleteData(int id) async {
    await SqlHelper.deleteNotes(id);
  }

  Future<void> createData(NotesResult data) async {
    await SqlHelper.createNotes(data);
    descriptionController.clear();
    _getData();
  }

  Future<void> _updateData(NotesResult data, int id) async {
    await SqlHelper.updateNotes(data, id);

    _getData();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Widget showModal() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        height: 250,
        child: Column(
          children: [
            TextField(
              autocorrect: false,
              controller: descriptionController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await createData(
                  NotesResult(description: descriptionController.text),
                );
                setState(() {
                  isOpen = false;
                });
              },
              child: const Text('save'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotesApp'),
      ),
      body: isOpen ? showModal() : _buildList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isOpen = !isOpen;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  GridView _buildList() {
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: _data.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        final data = _data[index];
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(data: data),
              )),
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['description'],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _deleteData(data['id']);
                        _getData();
                      },
                      icon: const Icon(Icons.delete, size: 20),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
