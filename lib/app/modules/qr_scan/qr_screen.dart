import 'package:akij_project/app/modules/qr_scan/controller/cubit/qr_cubit.dart';
import 'package:akij_project/app/utils/widgets/gradientCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileScannerScreen extends StatefulWidget {
  static String routeName = '/Qr-screen';

  const MobileScannerScreen({super.key});

  @override
  State<MobileScannerScreen> createState() => _MobileScannerScreenState();
}

class _MobileScannerScreenState extends State<MobileScannerScreen> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: const Color.fromARGB(166, 255, 64, 128),
        title: const Text(
          "QR Code result",
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
          SliverToBoxAdapter(
            child: BlocBuilder<QrCubit, QrState>(
              builder: (context, state) {
                if (state is QrResultLoading) {
                  return CircularProgressIndicator();
                } else if (state is QrResult) {
                  return GradientCard(
                    content: state.qrRes.toString(),
                  );
                } else {
                  return const GradientCard(content: "Server Error");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
