import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/slot_change_cubit.dart';
import 'package:pes/volunteer_screen/all_slots_screen.dart';

class SideDrawer extends StatelessWidget {
  SlotChangeCubit? slotChangeCubit;
  @override
  Widget build(BuildContext context) {
    slotChangeCubit = BlocProvider.of<SlotChangeCubit>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: Center(
              child: Text(
                'Volunteer',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xff274D76),
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.home),
          //   title: const Text('Home'),
          //   onTap: () => {},
          // ),
          ListTile(
            leading: const Icon(IconData(0xf522, fontFamily: 'MaterialIcons')),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushNamed(context, PROFILE);
            },
          ),
          ListTile(
            leading: const Icon(IconData(0xf5fe, fontFamily: 'MaterialIcons')),
            title: const Text('All Slots'),
            onTap: () {
              //pass 1 as a variable so that concerned data can be retrieved
              Navigator.of(context).pop();
              Navigator.popUntil(context, (route) => route.isFirst);
              slotChangeCubit!.emit(SlotChangeInitial());
              Navigator.pushNamed(context, ALL_SLOTS);
            },
          ),
          // ListTile(
          //   leading: const Icon(IconData(0xf37f, fontFamily: 'MaterialIcons')),
          //   title: const Text('Student Needs'),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.popUntil(context, (route) => route.isFirst);
          //     Navigator.pushNamed(context, NEEDS);
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              BlocProvider.of<LoginCubit>(context).storeToken("").then(
                  (value) => BlocProvider.of<LoginCubit>(context).login());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
