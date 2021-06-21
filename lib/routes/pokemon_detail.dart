import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pokedex/services/functions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/services/api.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonDetailPage extends StatefulWidget {
  final int pokemonIndex;
  const PokemonDetailPage(this.pokemonIndex);

  @override
  _PokemonDetailPageState createState() =>
      _PokemonDetailPageState(pokemonIndex);
}

class Type {
  final String typeName;
  Type({required this.typeName});
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  int pokemonIndex;
  _PokemonDetailPageState(this.pokemonIndex);

  Future<List<dynamic>> fetchPokemonDetails() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              if (snapshot.hasData) {
                if (snapshot.data[pokemonIndex]["type"][1] == null) {
                  print('does not exist');
                } else {
                  print('exist');
                }
                return pokemonDetailScreen(
                  name:
                      snapshot.data[pokemonIndex]["name"]["english"].toString(),
                  id: snapshot.data[pokemonIndex]["id"],
                  sprite: snapshot.data[pokemonIndex]["sprite"].toString(),
                  hires: snapshot.data[pokemonIndex]["hires"].toString(),
                  types: snapshot.data[pokemonIndex]["type"],
                  description:
                      snapshot.data[pokemonIndex]["description"].toString(),
                  species: snapshot.data[pokemonIndex]["species"].toString(),
                  primaryType:
                      snapshot.data[pokemonIndex]["type"][0].toString(),
                  baseHP: snapshot.data[pokemonIndex]["base"]["HP"].toDouble(),
                  baseAttack:
                      snapshot.data[pokemonIndex]["base"]["Attack"].toDouble(),
                  baseDefense:
                      snapshot.data[pokemonIndex]["base"]["Defense"].toDouble(),
                  baseSpAttack: snapshot.data[pokemonIndex]["base"]
                          ["Sp. Attack"]
                      .toDouble(),
                  baseSpDefense: snapshot.data[pokemonIndex]["base"]
                          ["Sp. Defense"]
                      .toDouble(),
                  baseSpeed:
                      snapshot.data[pokemonIndex]["base"]["Speed"].toDouble(),
                );
              } else if (snapshot.hasError) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              // By default, show a loading spinner.
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
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
    required String description,
    required String species,
    required double baseHP,
    required double baseAttack,
    required double baseDefense,
    required double baseSpAttack,
    required double baseSpDefense,
    required double baseSpeed,
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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/img/pokeball-bg.png"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 75.0,
                      left: 30.0,
                      right: 30.0,
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
                ],
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.25,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new CachedNetworkImageProvider(hires),
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
          padding: const EdgeInsets.all(
            30.0,
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
                        image: new CachedNetworkImageProvider(sprite),
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ),
                child: Text(
                  description,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.5,
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
                  bottom: 20.0,
                ),
                child: Text(
                  "Base Stats",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22.0,
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15.0,
                                ),
                                child: Text(
                                  "HP",
                                  style: TextStyle(
                                    color: getPrimaryTypeColor(primaryType),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15.0,
                                ),
                                child: Text(
                                  "Attack",
                                  style: TextStyle(
                                    color: getPrimaryTypeColor(primaryType),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15.0,
                                ),
                                child: Text(
                                  "Defense",
                                  style: TextStyle(
                                    color: getPrimaryTypeColor(primaryType),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15.0,
                                ),
                                child: Text(
                                  "Sp. Attack",
                                  style: TextStyle(
                                    color: getPrimaryTypeColor(primaryType),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15.0,
                                ),
                                child: Text(
                                  "Sp. Defense",
                                  style: TextStyle(
                                    color: getPrimaryTypeColor(primaryType),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 15.0,
                                ),
                                child: Text(
                                  "Speed",
                                  style: TextStyle(
                                    color: getPrimaryTypeColor(primaryType),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              getBaseStat(baseHP, types[0]),
                              getBaseStat(baseAttack, types[0]),
                              getBaseStat(baseDefense, types[0]),
                              getBaseStat(baseSpAttack, types[0]),
                              getBaseStat(baseSpDefense, types[0]),
                              getBaseStat(baseSpeed, types[0]),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
