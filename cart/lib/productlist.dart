import 'package:cart/cardprovider.dart';
import 'package:cart/cartmodel.dart';
import 'package:cart/cartscren.dart';
import 'package:cart/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as bages;
import 'package:provider/provider.dart';


class productlistscreen extends StatefulWidget {
  const productlistscreen({Key? key}) : super(key: key);

  @override
  State<productlistscreen> createState() => _productlistscreenState();
}

class _productlistscreenState extends State<productlistscreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> productName = [
    'Cucumber',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List<String> productUnit = [
    'G',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://cdn.pixabay.com/photo/2015/07/17/13/44/cucumbers-849269_960_720.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<cartprovider>(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,

        title: Text("product list"),
        centerTitle: true,
        actions:  [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => cartscreen()));
            },
            child: Center(
              child: bages.Badge(
                badgeContent: Consumer<cartprovider>(
                  builder:  (context,value,child){
                    return Text(value.getcounter().toString(),style: TextStyle(color: Colors.black));
                  },
                ),
                badgeAnimation: bages.BadgeAnimation.slide(
                  animationDuration: Duration(microseconds: 500),
                ),

                child: Icon(Icons.shopping_cart),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: productName.length,
            itemBuilder: (context, index) {
              return Card(
                  elevation: 10,
                  shadowColor: Colors.green,
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
                              image:
                                  NetworkImage(productImage[index].toString())),
                          SizedBox(width: 5),
                          SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productName[index].toString()),
                                SizedBox(height: 5),
                                Text(productUnit[index].toString() +
                                    " " +
                                    productPrice[index].toString()),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      dbHelper!
                                          .insert(Cart(
                                              id: index,
                                              productId: index.toString(),
                                              productName: productName[index].toString(),
                                              initialPrice: productPrice[index],
                                              productPrice: productPrice[index],
                                              quantity: 1,
                                              unitTag:
                                                  productUnit[index].toString(),
                                              image: productImage[index]
                                                  .toString()))
                                          .then((value) {
                                        print('product is added to cart ');
                                        cart.addprice(double.parse(productPrice[index].toString()));
                                        cart.addcounter();

                                      }).onError((error, stackTrace) {
                                        print(error.toString());
                                      });
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 100,

                                      decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.lightGreen,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 25.0,
                                            color: Colors.grey,
                                          )
                                        ]
                                      ),


                                        child: Center(
                                          child: const Text(
                                            'Add to cart',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),

                                    ),
                                  ),
                                )
                              ],
                            ),
                          )

                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          )),
          


        ],

      ),
    );
  }
}



