import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vibration/vibration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

final bdNube = Firestore.instance;

String petalo = "";
String duracion = "";
String status = '';
String peticion="no";
Color colorAppBar=Colors.green;

void main() => runApp(Florever());

class Florever extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Estado();
}

class Estado extends State {

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
        appBar: AppBar(backgroundColor: colorAppBar,
            title: Text("Pétalo: $petalo Duración: $duracion ")),
        body: (Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Center(
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        child: Image.asset('imagenes/florever.png'),
                        opacity: 0.6,
                      ),

                      Positioned(
                          top: 0,
                          left: 162,
                          child: GestureDetector(
                            child: Image.asset('imagenes/petalovertical.png'),
                            onTap: () {
                              touch('2', '255', 'on');
                            },
                          )),

                      Positioned(
                          top: 50,
                          left: 200,
                          child: GestureDetector(
                            child: Image.asset('imagenes/petalodiagonalder.png'),
                            onTap: () {
                              touch('3', '255', 'on');
                            },
                          )),

                      Positioned(
                          top: 162,
                          right: 0,
                          child: GestureDetector(
                            child: Image.asset('imagenes/petalohorizontal.png'),
                            onTap: () {
                              touch('4', '255', 'on');
                            },
                          )),

                      Positioned(
                          top: 200,
                          left: 200,
                          child: GestureDetector(
                            child: Image.asset('imagenes/petalodiagonalizq.png'),
                            onTap: () {
                              touch('5', '255', 'on');
                            },
                          )),

                      Positioned(
                          bottom: 35,
                          left: 162,
                          child: GestureDetector(
                            child: Image.asset('imagenes/petalovertical.png'),
                            onTap: () {
                              touch('6', '255', 'on');
                            },
                          )),

                      Positioned(
                          top: 200,
                          left: 49,
                          child: GestureDetector(
                            child: Image.asset('imagenes/petalodiagonalder.png'),
                            onTap: () {
                              touch('7', '255', 'on');
                            },
                          )),

                      Positioned(
                          top: 162,
                          left: 0,
                          child: GestureDetector(
                            child: Image.asset('imagenes/petalohorizontal.png'),
                            onTap: () {
                              touch('8', '255', 'on');
                            },
                          )),

                      Positioned(
                          top: 50,
                          left: 47,
                          child: GestureDetector(
                            child: Image.asset('imagenes/petalodiagonalizq.png'),
                            onTap: () {
                              touch('9', '255', 'on');
                            },
                          )),

                      //CENTRO 1
                      Positioned(
                          top: 98,
                          left: 95,
                          child: GestureDetector(
                            child: Image.asset(
                              'imagenes/centro1.png',
                            ),
                            onTap: () {
                              touch('A', '255', 'on');
                            },
                          )),

                      //CENTRO 2
                      Positioned(
                          top: 120,
                          left: 120,
                          child: GestureDetector(
                            child: Image.asset('imagenes/centro2.png'),
                            onTap: () {
                              touch('B', '255', 'on');
                            },
                          )),

                      //CENTRO 3
                      Positioned(
                          top: 157,
                          left: 157,
                          child: GestureDetector(
                            child: Image.asset('imagenes/centro3.png'),
                            onTap: () {
                              touch('C', '255', 'on');
                            },
                          )),

                    ],
                  ),
                ),
              ),
            ),

            GestureDetector(child:
            Image.asset('imagenes/corazon.png', width: 100,),
              onTap: (){
                touch('D', '255', 'on');
              },
            ),


// ------------------ BATI SEñAL
            StreamBuilder(
              stream: Firestore.instance.collection('Ghost').snapshots(),
              builder: (context, snapshot){
                DocumentSnapshot cursor = snapshot.data.documents[0];
                peticion=cursor.data['peticion'];
                print('Peticion: $peticion}');
                var batisenal;

                if(peticion=='no') {
                  batisenal = Container(
                    color: Colors.green,
                    width: 400,
                    height: 40,
                  );
                }
                else {
                  batisenal = Container(
                    color: Colors.red,
                    width: 400,
                    height: 40,
                  );
          //        Vibration.vibrate(duration: 500);
                }
                return batisenal;
              },
            ),

// ------------------ CONSULTA DEL ESTADO ACTUAL
            Padding(padding: EdgeInsets.all(5.0),
              child: Container(
                width: 400,
                height: 40,
                child: RaisedButton(
                    child: Text('CONSULTAR'),
                    color: Colors.green,
                    textColor: Colors.white,
                    elevation: 8.0,
                    highlightElevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      consultar();
                      setState(() {
                        petalo = petalo;
                        duracion = duracion;
                        status = status;
                      });
                    }),),
            ),


          ],
        ))),
  );
}






void insertarTimeStamp() async {
  await bdNube.collection("Log").document(DateTime.now().toString()).setData({
    'Timestamp': DateTime.now().toString(),
  });
}

void touch(String petalo, String duracion, String status) async {
  await bdNube
      .collection('Ghost')
      .document('touch')
      .setData({'petalo': petalo, 'duracion': duracion, 'status': status});

  Vibration.vibrate(duration: 200);
  print(petalo);
}

void consultar() async {
  await bdNube
      .collection('Ghost')
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((documento) {
      petalo = documento.data['petalo'];
      duracion = documento.data['duracion'];
      status = documento.data['status'];
      return print('Pétalo $petalo, Duracion $duracion, status $status');
    });
  });
}

/*
void modificar() async {
  try {
    await bdNube
        .collection('florever')
        .document('305023')
        .updateData({'Nombre': 'Felipe'});
  } catch (e) {
    print(e.toString());
  }
}

void eliminar() async {
  await bdNube.collection('Log').document('305023').delete();
}
*/
