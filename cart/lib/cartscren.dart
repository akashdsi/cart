import 'package:cart/cartmodel.dart';
import 'package:cart/dbhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as bages;
import 'cardprovider.dart';

class cartscreen extends StatefulWidget {
  const cartscreen({Key? key}) : super(key: key);

  @override
  State<cartscreen> createState() => _cartscreenState();
}

class _cartscreenState extends State<cartscreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<cartprovider>(context);
    return Scaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Cart"),
        centerTitle: true,
        actions: [
          Center(
            child: bages.Badge(
              badgeContent: Consumer<cartprovider>(
                builder: (context, value, child) {
                  return Text(value.getcounter().toString(),
                      style: TextStyle(color: Colors.black));
                },
              ),
              badgeAnimation: bages.BadgeAnimation.slide(),
              child: Icon(Icons.shopping_cart),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body:

      Column(

        children: [
          FutureBuilder(


              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> Snapshot) {

                if (Snapshot.hasData) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: Snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Image(
                                        height: 100,
                                        width: 100,
                                        image: NetworkImage(Snapshot
                                            .data![index].image
                                            .toString())),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(Snapshot
                                                  .data![index].productName
                                                  .toString()),
                                              InkWell(
                                                  onTap: () {
                                                    print(Snapshot.data![index]
                                                        .productPrice
                                                        .toString());
                                                    dbHelper?.deleteCartItem(
                                                        Snapshot
                                                            .data![index].id!);
                                                    cart.removecounter();
                                                    cart.removeprice(double.parse(
                                                        Snapshot.data![index]
                                                            .productPrice
                                                            .toString()));
                                                  },
                                                  child: Icon(Icons.delete)),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(Snapshot.data![index].unitTag
                                                  .toString() +
                                              " " +
                                              Snapshot.data![index].productPrice
                                                  .toString()),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                                height: 25,
                                                width: 100,
                                                decoration: BoxDecoration(

                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        int quantitiy = Snapshot
                                                            .data![index]
                                                            .quantity!;
                                                        int price = Snapshot
                                                            .data![index]
                                                            .productPrice!;
                                                        quantitiy++;
                                                        int? newprice =
                                                            quantitiy * price;
                                                        print('added');

                                                        dbHelper
                                                            ?.updateQuantity(Cart(
                                                                id: Snapshot
                                                                    .data![index]
                                                                    .id,
                                                                productId: Snapshot
                                                                    .data![index]
                                                                    .productId
                                                                    .toString(),
                                                                productName: Snapshot
                                                                    .data![index]
                                                                    .productName
                                                                    .toString(),
                                                                initialPrice: Snapshot
                                                                    .data![index]
                                                                    .initialPrice,
                                                                productPrice: Snapshot
                                                                    .data![index]
                                                                    .productPrice,
                                                                quantity:
                                                                    quantitiy,
                                                                unitTag: Snapshot
                                                                    .data![index]
                                                                    .unitTag,
                                                                image: Snapshot
                                                                    .data![index]
                                                                    .image
                                                                    .toString()))
                                                            .then((value) {
                                                          newprice = 0;
                                                          quantitiy = 0;
                                                          cart.addprice(double
                                                              .parse(Snapshot
                                                                  .data![index]
                                                                  .initialPrice!
                                                                  .toString()));
                                                        }).onError((error,
                                                                stackTrace) {
                                                          print(error.toString());
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.add_circle,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      Snapshot
                                                          .data![index].quantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          int quantitiy = Snapshot
                                                              .data![index]
                                                              .quantity!;
                                                          int price = Snapshot
                                                              .data![index]
                                                              .productPrice!;
                                                          quantitiy--;
                                                          int? newprice =
                                                              quantitiy * price;
                                                          print('removed');

                                                          if (quantitiy > 0) {
                                                            dbHelper
                                                                ?.updateQuantity(Cart(
                                                                    id: Snapshot
                                                                        .data![
                                                                            index]
                                                                        .id,
                                                                    productId: Snapshot
                                                                        .data![
                                                                            index]
                                                                        .productId
                                                                        .toString(),
                                                                    productName: Snapshot
                                                                        .data![
                                                                            index]
                                                                        .productName
                                                                        .toString(),
                                                                    initialPrice: Snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice,
                                                                    productPrice: Snapshot
                                                                        .data![
                                                                            index]
                                                                        .productPrice,
                                                                    quantity:
                                                                        quantitiy,
                                                                    unitTag: Snapshot
                                                                        .data![
                                                                            index]
                                                                        .unitTag,
                                                                    image: Snapshot
                                                                        .data![index]
                                                                        .image
                                                                        .toString()))
                                                                .then((value) {
                                                              newprice = 0;
                                                              quantitiy = 0;
                                                              cart.removeprice(double
                                                                  .parse(Snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!
                                                                      .toString()));

                                                              print(
                                                                  'Product Added to cart');
                                                            }).onError((error, stackTrace) {
                                                              print(error
                                                                  .toString());
                                                            });
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.remove_circle,
                                                          color: Colors.grey,
                                                        ))
                                                  ],
                                                )),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ));
                } else {}
                return Text("");
              }),
          Consumer<cartprovider>(builder: (context, value, child) {
            return Visibility(
              visible:
                  value.getprice().toStringAsFixed(2) == "0.00" ? false : true,
              child: Column(
                children: [
                  reusable(
                      title: 'Total',
                      value: r'$' + value.getprice().toStringAsFixed(1))
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

class reusable extends StatelessWidget {
  final String title, value;
  const reusable({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 150,


      color: Colors.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(
                  title,
                  style: const TextStyle(fontSize: 13,fontWeight: FontWeight.normal),
                ),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 21,fontWeight: FontWeight.bold,),
                  ),],
              ),Container(
                height: 55,
                width: 144,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(34)

                ),
                child: Row(
                  children: [
                    SizedBox(width:35),
                    Text('Checkout',style: TextStyle(color: Colors.white)),
                    Icon(Icons.arrow_forward,color:Colors.white),
                  ],
                ),
              )
              // SizedBox(
              //   width: 1,
              // ),

              // SizedBox(
              //   width: 0.1,
              // ),
            ],
          ),
        ),
        // SizedBox(height: 50,),
      ]),
    );
  }
}
