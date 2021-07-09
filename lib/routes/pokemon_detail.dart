import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Pokedex/services/functions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonDetailPage extends StatefulWidget {
  final int pokemonIndex;
  final List<dynamic> pokemonListData;
  final List<dynamic> typesList;
  const PokemonDetailPage(
      this.pokemonIndex, this.pokemonListData, this.typesList);

  @override
  _PokemonDetailPageState createState() =>
      _PokemonDetailPageState(pokemonIndex, pokemonListData, typesList);
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  int pokemonIndex;
  List<dynamic> pokemonListData;
  List<dynamic> typesList = [];
  _PokemonDetailPageState(
      this.pokemonIndex, this.pokemonListData, this.typesList);

  Future<List<dynamic>> fetchPokemonDetails() async {
    return await pokemonListData;
  }

  Future<List<dynamic>> fetchPokemonResistances() async {
    return await typesList;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      // status icon and text color, dark:black  light:white
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: FutureBuilder<List<dynamic>>(
            future: fetchPokemonDetails(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (pokemonListData.length != 0) {
                return pokemonDetailScreen(
                  name: pokemonListData[pokemonIndex]["name"]["english"]
                      .toString(),
                  id: pokemonListData[pokemonIndex]["id"],
                  sprite: pokemonListData[pokemonIndex]["sprite"].toString(),
                  hires: pokemonListData[pokemonIndex]["hires"].toString(),
                  thumbnail:
                      pokemonListData[pokemonIndex]["thumbnail"].toString(),
                  types: pokemonListData[pokemonIndex]["type"],
                  evolutions: pokemonListData[pokemonIndex]["evolution"],
                  description:
                      pokemonListData[pokemonIndex]["description"].toString(),
                  species: pokemonListData[pokemonIndex]["species"].toString(),
                  primaryType:
                      pokemonListData[pokemonIndex]["type"][0].toString(),
                  baseHP:
                      pokemonListData[pokemonIndex]["base"]["HP"].toDouble(),
                  baseAttack: pokemonListData[pokemonIndex]["base"]["Attack"]
                      .toDouble(),
                  baseDefense: pokemonListData[pokemonIndex]["base"]["Defense"]
                      .toDouble(),
                  baseSpAttack: pokemonListData[pokemonIndex]["base"]
                          ["Sp. Attack"]
                      .toDouble(),
                  baseSpDefense: pokemonListData[pokemonIndex]["base"]
                          ["Sp. Defense"]
                      .toDouble(),
                  baseSpeed:
                      pokemonListData[pokemonIndex]["base"]["Speed"].toDouble(),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget pokemonDetailScreen({
    required String name,
    required int id,
    required List<dynamic> types,
    required String primaryType,
    required String sprite,
    required String hires,
    required String thumbnail,
    required String description,
    required String species,
    required double baseHP,
    required double baseAttack,
    required double baseDefense,
    required double baseSpAttack,
    required double baseSpDefense,
    required double baseSpeed,
    required Map<String, dynamic> evolutions,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: getPrimaryTypeColor(primaryType),
            borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width * 3, 200.0)),
          ),
          child: Stack(
            children: [
              Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.height * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/img/pokeball-bg.png"),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 0.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "#" + id.toString().padLeft(3, '0'),
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white.withOpacity(0.75),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            height: 34,
                            width: MediaQuery.of(context).size.width * 0.5,
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 7.5,
                                      horizontal: 7.5,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/img/types/${types[index].toString().toLowerCase()}.svg',
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.33,
                  height: MediaQuery.of(context).size.height * 0.33,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(hires),
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            top: 30.0,
            right: 20.0,
            left: 20.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pokédex Entry",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22.0,
                ),
              ),
              Row(
                children: [
                  Text(
                    "The " + species,
                    style: TextStyle(
                      color: getPrimaryTypeColor(primaryType),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 5.0,
                    ),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(sprite),
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: types.length,
                        itemBuilder: (context, index) {
                          final type = types[index];
                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 15.0,
                            ),
                            child: Card(
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7.5,
                                  horizontal: 17.0,
                                ),
                                child: Text(
                                  types[index].toString().toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 25.0,
                ),
                child: Text(
                  description,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0,
                  ),
                ),
              ),
              DefaultTabController(
                length: 3,
                child: Container(
                    //  height: 45,
                    height: 350,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 20.0,
                          ),
                          padding: const EdgeInsets.all(0),
                          child: TabBar(
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            indicatorColor: Colors.transparent,
                            labelColor: Colors.white,
                            unselectedLabelColor:
                                getPrimaryTypeColor(primaryType),
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: getPrimaryTypeColor(primaryType)),
                            labelPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 7.5,
                            ),
                            tabs: [
                              Tab(
                                icon: Text(
                                  "Stats",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Tab(
                                icon: Text(
                                  "Evolution",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Tab(
                                icon: Text(
                                  "Resistance",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Stats
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 15.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            getBaseStatLabel("HP"),
                                            getBaseStatLabel("Attack"),
                                            getBaseStatLabel("Defense"),
                                            getBaseStatLabel("Sp. Attack"),
                                            getBaseStatLabel("Sp. Defense"),
                                            getBaseStatLabel("Speed"),
                                            getBaseStatLabel("Base Total"),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            getBaseStat(baseHP, types[0], 255),
                                            getBaseStat(
                                                baseAttack, types[0], 255),
                                            getBaseStat(
                                                baseDefense, types[0], 255),
                                            getBaseStat(
                                                baseSpAttack, types[0], 255),
                                            getBaseStat(
                                                baseSpDefense, types[0], 255),
                                            getBaseStat(
                                                baseSpeed, types[0], 255),
                                            getBaseStat(
                                                (baseHP +
                                                    baseAttack +
                                                    baseDefense +
                                                    baseSpAttack +
                                                    baseSpDefense +
                                                    baseSpeed),
                                                types[0],
                                                750),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              // Evolutions
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // if pokemon has previous evolution
                                      if (pokemonListData[pokemonIndex]
                                              ["evolution"]["prev"] !=
                                          null)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 30,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => PokemonDetailPage(
                                                                  int.parse((pokemonListData[pokemonIndex]["evolution"]["prev"]
                                                                              [
                                                                              0])
                                                                          .toString()) -
                                                                      1,
                                                                  pokemonListData,
                                                                  typesList)),
                                                        );
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              pokemonListData[int.parse((pokemonListData[pokemonIndex]["evolution"]
                                                                              [
                                                                              "prev"]
                                                                          [
                                                                          0])) -
                                                                      1]["thumbnail"]
                                                                  .toString(),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_right_alt_rounded,
                                                        size: 30,
                                                        color: Colors.black
                                                            .withOpacity(0.25),
                                                      ),
                                                      Text(
                                                        pokemonListData[pokemonIndex]
                                                                    [
                                                                    "evolution"]
                                                                ["prev"][1]
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image:
                                                            CachedNetworkImageProvider(
                                                                thumbnail),
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      // if pokemon has next evolution
                                      if (pokemonListData[pokemonIndex]
                                              ["evolution"]["next"] !=
                                          null)
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image:
                                                            CachedNetworkImageProvider(
                                                                thumbnail),
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_right_alt_rounded,
                                                        size: 30,
                                                        color: Colors.black
                                                            .withOpacity(0.25),
                                                      ),
                                                      Text(
                                                        pokemonListData[pokemonIndex]
                                                                    [
                                                                    "evolution"]
                                                                ["next"][0][1]
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PokemonDetailPage(
                                                                    int.parse((pokemonListData[pokemonIndex]["evolution"]["next"][0][0])
                                                                            .toString()) -
                                                                        1,
                                                                    pokemonListData,
                                                                    typesList),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              pokemonListData[int.parse((pokemonListData[pokemonIndex]["evolution"]["next"]
                                                                              [
                                                                              0]
                                                                          [
                                                                          0])) -
                                                                      1]["thumbnail"]
                                                                  .toString(),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      // if pokemon has no evolutions
                                      if (pokemonListData[pokemonIndex]
                                                  ["evolution"]["next"] ==
                                              null &&
                                          pokemonListData[pokemonIndex]
                                                  ["evolution"]["prev"] ==
                                              null)
                                        Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          thumbnail),
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Does not evolve",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  FutureBuilder<List<dynamic>>(
                                    future: fetchPokemonResistances(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (typesList.length != 0) {
                                        return listOfWidgets();
                                      } else {
                                        return Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget listOfWidgets() {
    var list = ["one", "two", "three", "four"];
    return Wrap(
      runSpacing: 25,
      spacing: 25,
      runAlignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        for (var typeName in typesList)
          Container(
            margin: const EdgeInsets.only(
              top: 5.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.transparent, width: 0),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  color: getPrimaryTypeColor(typeName['english']),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 7.5,
                      horizontal: 7.5,
                    ),
                    child: SvgPicture.asset(
                      'assets/img/types/${typeName['english'].toString().toLowerCase()}.svg',
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                ),
                Text(
                  "x1",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
