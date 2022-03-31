import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptowallet_firebase/net/api_methods.dart';
import 'package:cryptowallet_firebase/net/flutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

double bitcoin = 0.0;
double ethereum = 0.0;
double tether = 0.0;

@override
  void initState() {
    super.initState();
    updateValues();
  }

  updateValues() async {
    bitcoin = await getPrice('eitcoin');
    ethereum = await getPrice('ethereum');
    tether = await getPrice('tether');
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    getValue(String id, double amount){
      if(id == 'bitcoin') {
        return (bitcoin * amount);
      }else if(id == 'ethereum'){
        return (ethereum * amount);
      }else{
        return (tether * amount);
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:  Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Coins')
            .snapshots(),
            builder: (BuildContext context, 
                AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(!snapshot.hasData){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0, 
                            left: 15.0, 
                            right: 15.0,
                            ),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 12.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.blue,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                const SizedBox(
                                  width: 5.0,
                                  ),
                                  Text('Coin: ${document.id}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                      'Price: \$' +  
                                      getValue(document.id, (document.data()as Map)['Amount']).toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                      color: Colors.red,
                                      ),
                                       onPressed: () async{
                                        await removeCoin(document.id);
                                      },
                                    )
                            ],),
                          ),
                        );
                      }).toList(),
                    
                  );
            },),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: ((context) => const AddView())));
        },
        child: const Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
    );
  }
}