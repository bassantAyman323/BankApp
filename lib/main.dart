import 'package:bloc/bloc.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sparks/screens/Transcations.dart';
import 'package:sparks/shared/bloc_observer.dart';
import 'package:sparks/shared/cubit/cubit.dart';
import 'package:sparks/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import 'contantas.dart';

void main() {
  BlocOverrides.runZoned(
        () {
      // Use blocs...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(const MyApp());
}
//1.create database/table
//2. open
//3. insert
//4. get/update

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
  //    title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.purple,

      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();

  var nameController=TextEditingController();
  var amountController=TextEditingController();
  List names=["Lila","Bassant","Arwa","Selim","Rozana","Bassem","Rowan","Fauzia","Samah","Koko"];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates states) {

          if(states is AppUpdateDataBaseState){
              Navigator.pop(context);
              amountController.text="";
              nameController.text="";
          }
        },
        builder: (BuildContext context, AppStates states) {
          AppCubit cubit=AppCubit.get(context);
          return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(

            title:Text( AppCubit.get(context).titles[cubit.currentIndex]),
          ),
          body:
              ConditionalBuilder(
                condition: states is! AppGetDataBaseStateLoading,
                builder:(context)=>cubit.screens[cubit.currentIndex] ,
                fallback: (context)=>Center(child: CircularProgressIndicator(),),
              ),
            floatingActionButton:
            FloatingActionButton(onPressed: (){
            if(cubit.isbottomsheet){
                if(formKey.currentState!.validate()){
                 // cubit.insertToDatabase(name: "bassant", balance: "2000");
                  cubit.UpdateDtataBase(transactions: double.parse(amountController.text), name: nameController.text);

                  // insertToDatabase(name:nameController.text ,balance:amountController.text ).then((value){

                  //   isbottomsheet=false;
                  //   setState(() {
                  //     fabIcon=Icons.edit;
                  //   });
                  // });

                }


            }else{
              scaffoldKey.currentState!.
            showBottomSheet((context) => Container(

              color: Colors.grey[200],
              padding: EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Transfer Money to:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                      TextFormField(
                        controller: nameController,
                        keyboardType:TextInputType.text,
                        validator: (value){
                          if(value==""){
                            return'name must not be empty';
                          }return null;

                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefix: Icon(Icons.title),


                        ),

                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: amountController,
                        keyboardType:TextInputType.number,
                        validator: (value){
                          if(value==""){
                            return'name must not be empty';
                          }    if(value!=""){

                          }
                          return null;

                        },
                        decoration: InputDecoration(

                          labelText: 'Amount',
                          prefix: Icon(Icons.monetization_on),


                        ),

                      ),

                    ],

                  ),
                ),
              ),
            )  , elevation:20.0,).closed.then((value) {


             cubit.changeBottomSheetState(isshow: false, icon: Icons.edit);
            });
              cubit.changeBottomSheetState(isshow: true, icon: Icons.add);


            }
            // insertToDatabase();

            // scaffoldKey.currentState.showBottomSheet((context) => null)
          },child: Icon(cubit.fabIcon),),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index){
              AppCubit.get(context).changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person_pin_outlined),label: 'Customers'),
              BottomNavigationBarItem(icon: Icon(Icons.transfer_within_a_station),label: 'Transcations'),
            ],

          ),


          // Column(
          //
          //
          //   children: <Widget>[
          //     Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(
          //           10,
          //         ),
          //         color: Colors.grey,
          //       ),
          //       width: 200,
          //       height: 50.0,
          //       child: MaterialButton(
          //         onPressed: (){
          //           Navigator.push(context, MaterialPageRoute(builder:(context)=>TransactionsPage() ));
          //         },
          //         child: Text(
          //           "Transcations",
          //           style: TextStyle(
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //
          //     ),
          //
          //
          //     FloatingActionButton(onPressed: (){
          //       if(isbottomsheet){
          //         //   setState(() {
          //         //   if(formKey.currentState!.validate()){
          //         //     insertToDatabase(name:nameController.text ,balance:amountController.text ).then((value){
          //         //       Navigator.pop(context);
          //         //       isbottomsheet=false;
          //         //       setState(() {
          //         //         fabIcon=Icons.edit;
          //         //       });
          //         //     });
          //         //
          //         //   }
          //         //
          //         //
          //         // });
          //       }else{ scaffoldKey.currentState!.
          //       showBottomSheet((context) => Container(
          //
          //         color: Colors.grey[200],
          //         padding: EdgeInsets.all(20.0),
          //         child: Padding(
          //           padding: const EdgeInsets.all(20.0),
          //           child: Form(
          //             key: formKey,
          //             child: Column(mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 TextFormField(
          //                   controller: nameController,
          //                   keyboardType:TextInputType.text,
          //                   validator: (value){
          //                     if(value==""){
          //                       return'name must not be empty';
          //                     }return null;
          //
          //                   },
          //                   decoration: InputDecoration(
          //                     labelText: 'Name',
          //                     prefix: Icon(Icons.title),
          //
          //
          //                   ),
          //
          //                 ),
          //                 SizedBox(
          //                   height: 15.0,
          //                 ),
          //                 TextFormField(
          //                   controller: amountController,
          //                   keyboardType:TextInputType.number,
          //                   validator: (value){
          //                     if(value==""){
          //                       return'name must not be empty';
          //                     }return null;
          //
          //                   },
          //                   decoration: InputDecoration(
          //
          //                     labelText: 'Amount',
          //                     prefix: Icon(Icons.monetization_on),
          //
          //
          //                   ),
          //
          //                 ),
          //
          //               ],
          //
          //             ),
          //           ),
          //         ),
          //       )  , elevation:20.0,).closed.then((value) {
          //
          //         isbottomsheet=false;
          //         // setState(() {
          //         //   fabIcon=Icons.edit;
          //         // });
          //       });
          //
          //       isbottomsheet=true;
          //
          //         // setState(() {
          //         //   fabIcon=Icons.add;
          //         // });
          //       }
          //       // insertToDatabase();
          //
          //       // scaffoldKey.currentState.showBottomSheet((context) => null)
          //     },child: Icon(fabIcon),)
          //
          //   ],
          // ),
          //
          // This trailing comma makes auto-formatting nicer for build methods.
        ); },

      ),
    );
  }




}

// class _MyHomePageState extends State<MyHomePage> {
//   late Database database;
//   var scaffoldKey=GlobalKey<ScaffoldState>();
//   var formKey=GlobalKey<FormState>();
//    bool isbottomsheet=false;
//   IconData fabIcon=Icons.edit;
//   var nameController=TextEditingController();
//   var amountController=TextEditingController();
//
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     createDatabase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//
//         title: Text(widget.title),
//       ),
//       body:
//       Column(
//
//
//         children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(
//               10,
//             ),
//             color: Colors.grey,
//           ),
//         width: 200,
//         height: 50.0,
//         child: MaterialButton(
//           onPressed: (){
// Navigator.push(context, MaterialPageRoute(builder:(context)=>TransactionsPage() ));
//           },
//           child: Text(
//            "Transcations",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//
//       ),
//
//
//        FloatingActionButton(onPressed: (){
//             if(isbottomsheet){setState(() {
//               if(formKey.currentState!.validate()){
//                 insertToDatabase(name:nameController.text ,balance:amountController.text ).then((value){
//                   Navigator.pop(context);
//                   isbottomsheet=false;
//                   setState(() {
//                     fabIcon=Icons.edit;
//                   });
//                 });
//
//               }
//
//
//             });}else{ scaffoldKey.currentState!.
//             showBottomSheet((context) => Container(
//
//               color: Colors.grey[200],
//               padding: EdgeInsets.all(20.0),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Form(
//                   key: formKey,
//                   child: Column(mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextFormField(
//                         controller: nameController,
//                           keyboardType:TextInputType.text,
//                         validator: (value){
//                           if(value==""){
//                             return'name must not be empty';
//                           }return null;
//
//                         },
//                         decoration: InputDecoration(
//                           labelText: 'Name',
//                           prefix: Icon(Icons.title),
//
//
//                   ),
//
//                       ),
//                       SizedBox(
//                         height: 15.0,
//                       ),
//                       TextFormField(
//                         controller: amountController,
//                         keyboardType:TextInputType.number,
//                         validator: (value){
//                           if(value==""){
//                             return'name must not be empty';
//                           }return null;
//
//                         },
//                         decoration: InputDecoration(
//
//                           labelText: 'Amount',
//                           prefix: Icon(Icons.monetization_on),
//
//
//                         ),
//
//                       ),
//
//                     ],
//
//                   ),
//                 ),
//               ),
//             )  , elevation:20.0,).closed.then((value) {
//
//               isbottomsheet=false;
//               setState(() {
//                 fabIcon=Icons.edit;
//               });
//             });
//
//               isbottomsheet=true;
//
//               setState(() {
//                 fabIcon=Icons.add;
//               });
//             }
//             // insertToDatabase();
//
//             // scaffoldKey.currentState.showBottomSheet((context) => null)
//           },child: Icon(fabIcon),)
//
//         ],
//       ),
//
//      // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//   void createDatabase()async{
//      database=await openDatabase(
//       'bank.db',
//       version: 1,
//       onCreate: (database,version)async{
//         print('database created');
//        await database.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, balance TEXT)');
//         print('table created');
//
//       },onOpen: (database){
//         getDataFromDataBase(database).then((value) {
//           data=value;
//           print(data);
//         });
//       print('database opened');
//
//
//     }
//     );
//
//   }
//   Future insertToDatabase({required String name,required String balance})async{
//     return await database.transaction((txn)async{
//     await txn.rawInsert('INSERT INTO Test(name,balance) VALUES("$name","$balance")').then((value){ print("$value inserted successfully");}).catchError((error){
//   print("error when inserting  Record ${error.toString()}");
//     });
//     return null;
//   });
//   }
//   Future<List<Map>> getDataFromDataBase(database)async{
//   return await database.rawQuery('SELECT * FROM Test');
//   // print(data);
//   }
//
//
//
// }

