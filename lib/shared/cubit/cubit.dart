import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparks/screens/Customers.dart';
import 'package:sparks/screens/HomeScreen.dart';
import 'package:sparks/screens/Transcations.dart';
import 'package:sparks/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../contantas.dart';

class AppCubit extends Cubit<AppStates>{
  //1.
  //intial state
  AppCubit(): super(AppInitialState());
  //object from me
  static AppCubit get(context)=>BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  List<Map> data=[];
  List<Map> transactiondata=[];
  bool isbottomsheet=false;
  IconData fabIcon=Icons.edit;
  List<Widget> screens = [
    HomeScreen(),
    CustomersScreen(),
    TransactionsPage(),

  ];

  List<String> titles = [
    'Sparks Bank',
    'Customers',
    'My Transcations',
  ];
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());

  }
  void createDatabase(){
  openDatabase(
        'bank.db',
        version: 1,
        onCreate: (database,version){
          print('database created');
           database.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT,email TEXT, balance REAL,transactions REAL)');
          print('table created');
         database.transaction((txn)async{
            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Lila",5000,"lila@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Bassant",5500,"bassant@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Arwa",60000,"Arwa@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Selim",2000,"selim@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            getDataFromDataBase(database);
            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Rozana",2000,"rozana@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            getDataFromDataBase(database);

            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Bassem",2000,"bassem@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            getDataFromDataBase(database);

            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Rowan",2000,"rowan@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            getDataFromDataBase(database);

            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Fauzia",2000,"fauzia@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            getDataFromDataBase(database);

            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Samah",2000,"samah@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            getDataFromDataBase(database);

            await txn.rawInsert('INSERT INTO Test(name,balance,email,transactions) VALUES("Koko",2000,"koko@gmail.com",0)')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            getDataFromDataBase(database);



         });


        },onOpen: (database){
      getDataFromDataBase(database);
      print('database opened');


    },
    ).then((value) {
      database = value;
      // Insert some records in a transaction


      emit(AppCreateDataBaseState());
    }
    );


  }
   insertToDatabase()async{
   await database.transaction((txn)async{
      await txn.rawInsert('INSERT INTO Test(name,balance,email) VALUES("lila",12,"toto@gmail.com")').then(
              (value){ print("$value inserted successfully");
              emit(AppInsertDataBaseState());
              getDataFromDataBase(database);
              }).catchError((error){
        print("error when inserting  Record ${error.toString()}");
      });
      return null;
    });
  }
  void getDataFromDataBase(database){
    // data=[];
    transactiondata=[];
    emit(AppGetDataBaseStateLoading());
     database.rawQuery('SELECT * FROM Test').then((value) {
      data=value;
      print(data);
      data.forEach((element) {
        if(element['transactions']!=0){
          transactiondata.add(element);
          // data.add(element);

        }
        print(element['transactions']); });

      emit(AppGetDataBaseState());

    }
    );;
    // print(data);
  }
  void changeBottomSheetState({required bool isshow, required IconData icon}){
    isbottomsheet=isshow;
    fabIcon=icon;
    emit(ChangeBottomSheetState());

  }
  void UpdateDtataBase({required double transactions,required String name })async{
  return   database.rawUpdate(
        'UPDATE Test SET transactions = ? WHERE name = ?',
        [transactions, '$name']).then((value) {
          getDataFromDataBase(database);
          emit(AppUpdateDataBaseState());

        });

  }

}
