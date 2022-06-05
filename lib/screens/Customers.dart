import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class CustomersScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {
        var data=AppCubit.get(context).data;
        return ListView.separated(
            itemBuilder: (context, index) =>BuildTask(data[index]),

            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
            itemCount: data.length);

      },

    );
  }
  Widget BuildTask(Map Model)=>  Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Expanded(
          child: Container(decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(10))

          ),height: 50,
            child: Center(
              child: Text(
                '${Model['name']}',
                style: TextStyle(
                    fontSize: 13.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color:  Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(10))

            ),height: 50,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(


                  '${Model['email']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(

                      color: Colors.black,
                      fontSize: 13.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.all(Radius.circular(10))

            ),height: 50,
            child: Center(
              child: Text(
                '${Model['balance']+Model['transactions']}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

      ],
    ),
  );
}