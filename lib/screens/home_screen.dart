import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetest/screens/login_screen.dart';
import 'package:firebasetest/services/auth_service.dart';
import 'package:firebasetest/services/firestore_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  //List<Product> productsList = [];

  late DocumentSnapshot _selectedProduct;
  final bool _isLoading = false;

  get addProductBox => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Home'),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                AuthService().signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ModalRoute.withName('/'),
                );
              })
        ],
      ),
      body: Stack(children: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(AuthService().getCurrentUserId() ?? "")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  if (documents.isNotEmpty) {
                    return GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      children: documents
                          .map((doc) => _gridViewItemContainer(doc))
                          .toList(),
                    );
                  } else {
                    return Center(
                      child: Container(
                        child: const Text('No product'),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Container(
                      child: const Text('No products'),
                    ),
                  );
                }
              },
            ),
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showProductBox(context, 'add');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _gridViewItemContainer(DocumentSnapshot doc) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(2, 4))
          ]),
      width: 80,
      child: Column(
        children: [
          Container(
            child: doc['imageUrl'] != null
                ? Image.network(doc['imageUrl'])
                : Image.network(
                    'https://www.google.com/search?q=soap+images&rlz=1C5CHFA_enLK1024LK1024&oq=soap+image&aqs=chrome.0.0i512j69i57j0i512l8.6747j0j7&sourceid=chrome&ie=UTF-8#imgrc=nFtTwU7Vn1EfHM'),
            height: 150,
          ),
          Container(
            child: Text(
              doc['name'],
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          Container(
            child: Text(
              doc['price'] + 'LKR',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _selectedProduct = doc;
                    showProductBox(context, 'update');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: (() {
                    CloudFirestoreService().deleteProduct(doc.id);
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  showProductBox(BuildContext context, String type) {
    bool isUpdateBox = false;

    isUpdateBox = (type != 'update') ? false : true;
    if (isUpdateBox) {
      _nameController.text = isUpdateBox ? _selectedProduct['name'] : '';
      _priceController.text = isUpdateBox ? _selectedProduct['price'] : '';
      _quantityController.text =
          isUpdateBox ? _selectedProduct['quantity'].toString() : '';
      _imageUrlController.text =
          isUpdateBox ? _selectedProduct['imageUrl'] : '';
    }

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        _emptyTextField();
      },
    );

    Widget saveButton = TextButton(
      child: Text(isUpdateBox ? 'update' : "Save"),
      onPressed: () async {
        if (_nameController.text.isNotEmpty &&
            _priceController.text.isNotEmpty &&
            _quantityController.text.isNotEmpty) {
          if (!isUpdateBox) {
            setState(() {
              CloudFirestoreService().addProduct(
                  _nameController.text,
                  _priceController.text,
                  int.parse(_quantityController.text),
                  _imageUrlController.text);
            });
          } else {
            setState(() {
              CloudFirestoreService().updateProduct(
                  _selectedProduct.id,
                  _nameController.text,
                  _priceController.text,
                  int.parse(_quantityController.text),
                  _imageUrlController.text);
            });
          }
          _emptyTextField();
          Navigator.pop(context);
        }
      },
    );
    AlertDialog productDetailsBox = AlertDialog(
      title: Text(isUpdateBox ? 'update Product' : "Add new poduct"),
      content: Container(
        child: Wrap(
          children: [
            Container(
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'price',
                  labelText: 'Price',
                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'quantity',
                  labelText: 'Quantity',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'image url',
                  labelText: 'Image Url',
                ),
              ),
            )
          ],
        ),
      ),
      actions: [
        saveButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addProductBox;
      },
    );
  }

  void _emptyTextField() {
    _nameController.text = '';
    _priceController.text = '';
    _quantityController.text = '';
    _imageUrlController.text = '';
  }
}
