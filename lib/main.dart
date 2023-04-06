import 'package:flutter/material.dart';
import 'package:webapp/ui.dart';
import './data/bools_helper.dart';
import 'favorite_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Books',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BookHelper helper;
  List<dynamic> books = <dynamic>[];
  late int booksCount;
  late TextEditingController txtSearchController;

  @override
  void initState() {
    helper = BookHelper();
    txtSearchController = TextEditingController();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;
    if (MediaQuery.of(context).size.width < 600) {
      isSmall = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My Books'),
        actions: <Widget>[
          InkWell(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: (isSmall) ? Icon(Icons.star) : Text('Favorites')),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FavoriteScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text('Search book'),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: 200,
                    child: TextField(
                      controller: txtSearchController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (text) {
                        helper.getBooks(text).then((value) {
                          setState(() {
                            books = value!;
                          });
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () =>
                          helper.getBooks(txtSearchController.text),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: (isSmall)
                  ? BookList( books, false)
                  : BooksTable(books, false),
            )
          ],
        ),
      ),
    );
  }

  Future initialize() async {
    books = (await helper.getBooks('JavaScript'))!;
    setState(() {
      booksCount = books.length;
      books = books;
    });
  }
}
