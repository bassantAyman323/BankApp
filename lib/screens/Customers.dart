import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';


import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class CustomersScreen extends StatelessWidget {
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();

  var nameController=TextEditingController();
  var amountController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {
        var data=AppCubit.get(context).data;
        return Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: ListView.separated(
              itemBuilder: (context, index) =>BuildTask(data[index],context),

              separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              itemCount: data.length),
        );

      },

    );
  }
  Widget BuildTask(Map Model,context)=>  Padding(

    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: (){
          showDialog(
            context: context,
            builder: (context2) {
              return AlertDialog(
                backgroundColor: Colors.grey[200],
                //bassant changed here
                title:  Text( 'Name: ${Model['name']}\nEmail: ${Model['email']}\nBalance: ${Model['balance']+Model['transactions']}',
                    style:TextStyle(color:Colors.black ) ),
                content:
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: amountController,
                        keyboardType:TextInputType.number,
                        validator: (value){
                          if(value==""){
                            return'Amount must not be empty';
                          }    if(value!=""){

                          }
                          return null;

                        },
                        decoration: InputDecoration(

                          labelText: 'Transfer amount:',
                          prefix: Icon(Icons.monetization_on),


                        ),

                      ),
                    ),
                actions: <Widget>[
                  new FlatButton(
                    child: const Text("Transfer"),
                    onPressed: () {
                    if(formKey.currentState!.validate()){
                      AppCubit.get(context).UpdateDtataBase(transactions: double.parse(amountController.text), name: '${Model['name']}');
                      amountController.text="";}
                },
                  ),
                  new FlatButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          // AppCubit.get(context).Selectspacific(name: '${Model['name']}');

        }, icon: Icon(Icons.arrow_forward_outlined)),


        Expanded(
          child: Container(

            decoration: BoxDecoration(
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
  void showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //bassant changed here
          title:  Text(""
              ///
              ,style:TextStyle(color:Colors.black ) ),

          actions: <Widget>[
            new FlatButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}