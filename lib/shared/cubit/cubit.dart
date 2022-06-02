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
           database.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT,email TEXT, balance TEXT,transactions TEXT)');
          print('table created');
         database.transaction((txn)async{
            await txn.rawInsert('INSERT INTO Test(name,balance,email) VALUES("lila","5000","lila@gmail.com")')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            await txn.rawInsert('INSERT INTO Test(name,balance,email) VALUES("bassant","5500","bassant@gmail.com")')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            await txn.rawInsert('INSERT INTO Test(name,balance,email) VALUES("Arwa","60000","Arwa@gmail.com")')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});
            await txn.rawInsert('INSERT INTO Test(name,balance,email) VALUES("Selim","2000","selim@gmail.com")')
                .then((value){ print("$value inserted successfully");})
                .catchError((error){print("error when inserting  Record ${error.toString()}");});


          });


        },onOpen: (database){
      getDataFromDataBase(database).then((value) {
        data=value;
        print(data);

        emit(AppGetDataBaseState());

      }
      );
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
      await txn.rawInsert('INSERT INTO Test(name,balance,email) VALUES("lila","12","toto@gmail.com")').then(
              (value){ print("$value inserted successfully");
              emit(AppInsertDataBaseState());

              getDataFromDataBase(database).then((value) {
                data=value;
                print(data);
                emit(AppGetDataBaseState());

              }
              );
              }).catchError((error){
        print("error when inserting  Record ${error.toString()}");
      });
      return null;
    });
  }
  Future<List<Map>> getDataFromDataBase(database)async{
    emit(AppGetDataBaseStateLoading());
    return await database.rawQuery('SELECT * FROM Test');
    // print(data);
  }
  void changeBottomSheetState({required bool isshow, required IconData icon}){
    isbottomsheet=isshow;
    fabIcon=icon;
    emit(ChangeBottomSheetState());

  }

}
