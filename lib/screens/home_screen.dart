import 'package:flutter/material.dart';
import '../db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> recipes = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    final data = await DatabaseHelper().getRecipes();
    setState(() {
      recipes = data;
    });
  }

  Future<void> addOrUpdateRecipe({int? id}) async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) return;

    final recipe = {
      'title': title,
      'description': description,
      'image': 'assets/gambar/default.jpg'
    };

    if (id == null) {
      await DatabaseHelper().insertRecipe(recipe);
    } else {
      recipe['id'] = id as String;
await DatabaseHelper().updateRecipe(recipe);

    }

    _titleController.clear();
    _descriptionController.clear();

    loadRecipes();
    Navigator.of(context).pop();
  }

  Future<void> deleteRecipe(int id) async {
    await DatabaseHelper().deleteRecipe(id);
    loadRecipes();
  }

  void showForm({int? id, String? title, String? description}) {
    if (id != null) {
      _titleController.text = title!;
      _descriptionController.text = description!;
    } else {
      _titleController.clear();
      _descriptionController.clear();
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Resep'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi Resep'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => addOrUpdateRecipe(id: id),
              child: Text(id == null ? 'Tambah Resep' : 'Perbarui Resep'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masak Yuk!'),
      ),
      body: recipes.isEmpty
          ? const Center(child: Text('Tidak ada resep.'))
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                      recipe['image'] ?? 'assets/gambar/default.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(recipe['title']),
                    subtitle: Text(recipe['description'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showForm(
                            id: recipe['id'],
                            title: recipe['title'],
                            description: recipe['description'],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteRecipe(recipe['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
