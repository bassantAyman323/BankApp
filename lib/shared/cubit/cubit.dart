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
           database.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, balance TEXT)');
          print('table created');

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
      emit(AppCreateDataBaseState());
    }
    );

  }
   insertToDatabase({required String name,required String balance})async{
   await database.transaction((txn)async{
      await txn.rawInsert('INSERT INTO Test(name,balance) VALUES("$name","$balance")').then(
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
