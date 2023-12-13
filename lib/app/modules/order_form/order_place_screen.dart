import 'dart:convert';

import 'package:akij_project/app/modules/order_form/order_jsonformat.dart';
import 'package:akij_project/app/utils/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  static String routeName = '/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final List<TextEditingController> itemControllers = [];
  final List<TextEditingController> quantControllers = [];

  int textFieldCount = 1;

  @override
  void initState() {
    super.initState();
    itemControllers.add(TextEditingController());
    quantControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    itemControllers.forEach((controller) => controller.dispose());
    quantControllers.forEach((controller) => controller.dispose());
    shopNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          "Location and Punch",
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
      body: Form(
        key: formKey,
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 15)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: shopNameController,
                  labelText: 'Store Name',
                  icon: Icons.storefront_outlined,
                  inputType: TextInputType.name,
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 15)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: phoneNumberController,
                  labelText: 'Phone Number',
                  icon: Icons.phone_android,
                  inputType: TextInputType.number,
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Click Plus Button to add Items",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < textFieldCount; i++)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                TextInputField2(
                                  controller: itemControllers[i],
                                  labelText: 'Item ${i + 1}',
                                  icon: Icons.add_shopping_cart_outlined,
                                  inputType: TextInputType.text,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextInputField2(
                                  controller: quantControllers[i],
                                  labelText: 'Quantity of Items ${i + 1}',
                                  icon: Icons.queue_play_next_outlined,
                                  inputType: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                itemControllers.removeAt(i);
                                quantControllers.removeAt(i);

                                textFieldCount--;
                              });
                            },
                          ),
                        ],
                      ),
                    if (textFieldCount < 10)
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (textFieldCount < 10) {
                            setState(() {
                              itemControllers.add(TextEditingController());
                              quantControllers.add(TextEditingController());

                              textFieldCount++;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Maximum items reached (10)")),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 15)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: submitOrder,
                  child: Text(
                    'Submit Order',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.pinkAccent),
                  ),
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.symmetric(vertical: 15)),
          ],
        ),
      ),
    );
  }

  void submitOrder() {
    if (formKey.currentState!.validate()) {
      // Create an Order object
      Order order = Order(
        shopName: shopNameController.text,
        phoneNumber: phoneNumberController.text,
        items: List.generate(
          itemControllers.length,
          (index) => Item(
            itemName: itemControllers[index].text,
            quantity: int.tryParse(quantControllers[index].text) ?? 0,
          ),
        ),
      );

      // Convert the Order object to JSON format
      String orderJson = jsonEncode(order.toJson());

      // Navigate to another screen to display the JSON
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RawJsonScreen(jsonOrder: orderJson),
        ),
      );
    }
  }
}

class TextInputField2 extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final TextInputType inputType;

  const TextInputField2({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.inputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.pinkAccent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.pinkAccent,
          ),
        ),
      ),
    );
  }
}

/*


class GrowableTextField extends StatefulWidget {
  @override
  _GrowableTextFieldState createState() => _GrowableTextFieldState();
}

class _GrowableTextFieldState extends State<GrowableTextField> {
  final List<TextEditingController> itemControllers = [];
  final List<TextEditingController> quantControllers = [];

  int textFieldCount = 1;

  @override
  void initState() {
    super.initState();
    itemControllers.add(TextEditingController());
    quantControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    itemControllers.forEach((controller) => controller.dispose());
    quantControllers.forEach((controller) => controller.dispose());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < textFieldCount; i++)
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextInputField2(
                      controller: itemControllers[i],
                      labelText: 'Item ${i + 1}',
                      icon: Icons.add_shopping_cart_outlined,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextInputField2(
                      controller: quantControllers[i],
                      labelText: 'Quantity of Items ${i + 1}',
                      icon: Icons.queue_play_next_outlined,
                      inputType: TextInputType.text,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    itemControllers.removeAt(i);
                    quantControllers.removeAt(i);

                    textFieldCount--;
                  });
                },
              ),
            ],
          ),
        if (textFieldCount < 10)
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (textFieldCount < 10) {
                setState(() {
                  itemControllers.add(TextEditingController());
                  quantControllers.add(TextEditingController());

                  textFieldCount++;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Maximum items reached (10)")),
                );
              }
            },
          ),
      ],
    );
  }
}
*/

class Order {
  String shopName;
  String phoneNumber;
  List<Item> items;

  Order(
      {required this.shopName, required this.phoneNumber, required this.items});

  Map<String, dynamic> toJson() {
    return {
      'shopName': shopName,
      'phoneNumber': phoneNumber,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class Item {
  String itemName;
  int quantity;

  Item({required this.itemName, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'quantity': quantity,
    };
  }
}
