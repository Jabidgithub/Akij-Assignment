import 'package:akij_project/app/modules/google_map/geo_punch_list/controller/cubit/geo_punch_list_cubit.dart';
import 'package:akij_project/app/modules/google_map/geo_punch_list/model/geo_punch_model.dart';
import 'package:akij_project/app/utils/widgets/custom_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeoPunchListScreen extends StatefulWidget {
  static String routeName = '/geopunchlist-screen';

  const GeoPunchListScreen({super.key});

  @override
  State<GeoPunchListScreen> createState() => _GeoPunchListScreenState();
}

class _GeoPunchListScreenState extends State<GeoPunchListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(166, 255, 64, 128),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Geo Punched List",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            fontFamily: 'Roboto',
            shadows: [
              Shadow(
                color: Colors.pink,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          BlocBuilder<GeoPunchListCubit, GeoPunchListState>(
            builder: (context, state) {
              if (state is GeoPunchListFetched) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      GeoPunch geoPunch = state.punchList[index];

                      return GeoPunchCard(
                        geoPunch: geoPunch,
                      );
                    },
                    childCount: state.punchList.length,
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
