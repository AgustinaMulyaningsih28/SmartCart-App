import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  final String category;

  ShoppingListPage({required this.category});

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<Item> items = [
    Item(name: 'Susu', price: 55000),
    Item(name: 'Kopi', price: 30000),
    Item(name: 'Tepung Terigu', price: 20000),
    Item(name: 'Telur', price: 40000),
    Item(name: 'Blueband', price: 25000),
    Item(name: 'Yakult', price: 50000),
  ];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ItemDialog(
          onSave: (name, price) {
            setState(() {
              items.add(Item(name: name, price: price));
            });
          },
        );
      },
    );
  }

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ItemDialog(
          item: items[index],
          onSave: (name, price) {
            setState(() {
              items[index].name = name;
              items[index].price = price;
            });
          },
        );
      },
    );
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    int checkedPrice = items
        .where((item) => item.checked)
        .fold(0, (total, current) => total + current.price);
    int totalPrice = items.fold(0, (total, current) => total + current.price);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: Checkbox(
              value: item.checked,
              onChanged: (bool? value) {
                setState(() {
                  item.checked = value!;
                });
              },
            ),
            title: Text(item.name),
            subtitle: Text('Rp ${item.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editItem(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteItem(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Checked\nRp $checkedPrice'),
              Text('Total\nRp $totalPrice'),
            ],
          ),
        ),
      ),
    );
  }
}

class Item {
  String name;
  int price;
  bool checked;

  Item({required this.name, required this.price, this.checked = false});
}

class ItemDialog extends StatefulWidget {
  final Item? item;
  final Function(String, int) onSave;

  ItemDialog({this.item, required this.onSave});

  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _priceController.text = widget.item!.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Tambah Item' : 'Edit Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Item'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan nama item';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Harga Item'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan harga item';
                }
                if (int.tryParse(value) == null) {
                  return 'Masukkan harga yang valid';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _nameController.text,
                int.parse(_priceController.text),
              );
              Navigator.pop(context);
            }
          },
          child: Text('Simpan'),
          style: ElevatedButton.styleFrom(primary: Colors.orange),
        ),
      ],
    );
  }
}
