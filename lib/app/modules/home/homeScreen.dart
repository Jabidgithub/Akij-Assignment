import 'package:akij_project/app/modules/google_map/google_map_screen.dart';
import 'package:akij_project/app/modules/order_form/order_place_screen.dart';
import 'package:akij_project/app/modules/qr_scan/controller/cubit/qr_cubit.dart';
import 'package:akij_project/app/utils/widgets/button_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final QrCubit qrCubit = BlocProvider.of<QrCubit>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(166, 255, 64, 128),
        title: const Text(
          "Akij Group App",
          style: TextStyle(
            fontSize: 24.0,
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
          const SliverPadding(padding: EdgeInsets.symmetric(vertical: 15)),
          SliverToBoxAdapter(
            child: CustomButton(
              buttonText: 'Scan QR code',
              onPressed: () {
                qrCubit.ScanQrCode(context);
              },
              iconsName: Icons.qr_code,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.symmetric(vertical: 15)),
          SliverToBoxAdapter(
            child: CustomButton(
              buttonText: 'Geo Punch Submit',
              onPressed: () {
                Navigator.of(context).pushNamed(GoogleMapScreen.routeName);
              },
              iconsName: Icons.location_city,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.symmetric(vertical: 15)),
          SliverToBoxAdapter(
            child: CustomButton(
              buttonText: 'Submit Order',
              onPressed: () {
                Navigator.of(context).pushNamed(OrderScreen.routeName);
              },
              iconsName: Icons.list_alt_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
