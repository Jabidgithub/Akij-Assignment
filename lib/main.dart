import 'package:akij_project/app/modules/google_map/controller/cubit/geo_punch_cubit.dart';
import 'package:akij_project/app/modules/google_map/geo_punch_list/controller/cubit/geo_punch_list_cubit.dart';
import 'package:akij_project/app/modules/google_map/geo_punch_list/geo_punch_list_screen.dart';
import 'package:akij_project/app/modules/google_map/google_map_screen.dart';
import 'package:akij_project/app/modules/home/homeScreen.dart';
import 'package:akij_project/app/modules/qr_scan/controller/cubit/qr_cubit.dart';
import 'package:akij_project/app/modules/qr_scan/qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';

import 'app/modules/order_form/order_place_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => QrCubit()),
        BlocProvider(create: (context) => GeoPunchCubit()),
        BlocProvider(create: (context) => GeoPunchListCubit()),
      ],
      child: MaterialApp(
        title: 'Akij Interview',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          GoogleMapScreen.routeName: (context) => GoogleMapScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
          GeoPunchListScreen.routeName: (context) => const GeoPunchListScreen(),
          MobileScannerScreen.routeName: (context) =>
              const MobileScannerScreen(),
        },
        initialRoute: HomeScreen.routeName,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
