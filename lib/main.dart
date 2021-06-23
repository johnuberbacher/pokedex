import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'routes/pokemon_detail.dart';
import 'services/functions.dart';
import 'services/api.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent, // Android System bar
    statusBarBrightness: Brightness.light, // iOS System Bar
    systemNavigationBarDividerColor:
        Colors.black.withOpacity(0.075), // Android Navigation Bar Divider
    systemNavigationBarColor: Colors.white, // Android Navigation Bar
    systemNavigationBarIconBrightness:
        Brightness.dark, // Android Navigation Bar Icons
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
            // side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
          ),
        ),
        primarySwatch: Colors.red,
        accentColor: Colors.grey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> pokemonGlobalList = [];
  List<dynamic> pokemonList = [];
  List<dynamic> filteredList = [];
  List<dynamic> searchList = [];
  String searchText = "";
  bool isLoading = false;
  Icon searchIcon = Icon(
    Icons.search,
    color: Colors.black.withOpacity(0.33),
  );
  TextEditingController controller = TextEditingController(text: "");

  _fetchPokemonList() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      pokemonList = jsonResponse;
      searchList = [];
      for (int i = 0; i < pokemonList.length; i++) {
        searchList.add(pokemonList[i]);
      }
    } else {
      throw Exception("Failed to load Pokemon.");
    }
    setState(() {
      pokemonList = searchList;
      filteredList = pokemonList;
      isLoading = false;
    });
  }

  Widget _pokemonList() {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            padding: EdgeInsets.all(0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return pokemonCard(
                name: filteredList[index]["name"]["english"].toString(),
                types: filteredList[index]["type"],
                id: filteredList[index]["id"],
                thumbnail: filteredList[index]["thumbnail"].toString(),
                primaryType: filteredList[index]["type"][0].toString(),
              );
            });
  }

  Widget _pokemonListSearchBar() {
    return Container(
      height: 50.0,
      margin: const EdgeInsets.only(
        top: 10.0,
        bottom: 15.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (text) {
                _filterPokemonList(text);
              },
              decoration: InputDecoration(
                prefixIcon: searchIcon,
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(100.0),
                  ),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 15.0,
                ),
                hintText: "Search for a Pokemon",
                filled: true,
                fillColor: Colors.black.withOpacity(0.075),
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.33)),
              ),
              style: TextStyle(
                color: Colors.black.withOpacity(0.66),
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ), /*
          ClipRRect(
            child: Material(
              borderRadius: BorderRadius.circular(100),
              child: PopupMenuButton(
                  icon: Icon(
                    Icons.tune,
                    color: Colors.red,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text("First"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text("Second"),
                          value: 2,
                        )
                      ]),
            ),
          ),*/
        ],
      ),
    );
  }

  _filterPokemonList(String text) {
    setState(() {
      if (this.searchIcon.icon ==
          Icon(
            Icons.search,
            color: Colors.black.withOpacity(0.33),
          )) {
        this.searchIcon = new Icon(
          Icons.search,
          color: Colors.black.withOpacity(0.33),
        );
      } else {
        this.searchIcon = new Icon(
          Icons.search,
          color: Colors.black.withOpacity(0.33),
        );
      }
    });
    if (text.isEmpty) {
      setState(() {
        searchText = "";
        filteredList = pokemonList;
      });
    } else if (text.isNotEmpty) {
      List tempList = [];
      for (int i = 0; i < filteredList.length; i++) {
        if (filteredList[i]['name']['english']
            .toString()
            .toLowerCase()
            .contains(searchText.toString().toLowerCase())) {
          tempList.add(filteredList[i]);
        }
      }
      filteredList = tempList;
      setState(() {
        searchText = text.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.height * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/img/pokeball-bg-dark.png"),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        right: 15.0,
                        left: 15.0,
                        top: 15.0,
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Pokédex",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          _pokemonListSearchBar(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _pokemonList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pokemonCard({
    required String name,
    required String primaryType,
    required List<dynamic> types,
    required int id,
    required String thumbnail,
  }) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 15.0,
      ),
      child: Material(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: getPrimaryTypeColor(primaryType),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PokemonDetailPage(id - 1)),
            );
          },
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white.withOpacity(0.15),
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        right: 10.0,
                        left: 10.0,
                      ),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(thumbnail),
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 15.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 0.0,
                            bottom: 5.0,
                          ),
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 160,
                          height: 22.5,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: types.length,
                            itemBuilder: (context, index) {
                              final type = types[index];
                              return Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 2,
                                margin: const EdgeInsets.only(
                                  right: 10.0,
                                ),
                                color: getPrimaryTypeColor(types[index]),
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    types[index].toString().toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                right: 20,
                bottom: 18,
                child: Text(
                  "#" + id.toString().padLeft(3, '0'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
