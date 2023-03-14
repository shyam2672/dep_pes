import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/all_slots_cubit.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/notifications_cubit.dart';
import 'package:pes/cubit/slot_change_cubit.dart';
import 'package:pes/cubit/slots_cubit.dart';
import 'package:pes/data/models/notification.dart';
import 'package:pes/data/models/slots.dart';
import 'package:pes/data/models/user.dart';
import 'package:pes/data/repositories/main_server_repository.dart';
import 'package:pes/volunteer_screen/widgets/sidemenu.dart';
import 'package:pes/volunteer_screen/widgets/slot_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User user = User.empty(token: "");

  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  NotificationsCubit? notificationsCubit;
  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    notificationsCubit = BlocProvider.of<NotificationsCubit>(context);
    notificationsCubit!.getNotifications(user.token);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: SideDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropMaterialHeader(
          backgroundColor:
              appBarColor.withOpacity(0.8), //Theme.of(context).primaryColor,
        ),

        controller: _pageRefreshController,
        onRefresh: () {
          print("Refresh");
          setState(() {
            notificationsCubit!.notifications = [];
          });
          _pageRefreshController.refreshCompleted();
        },
        // onLoading: _onLoading,
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoaded) {
              return Container(
                color: appBarColor,
                child: Container(
                  padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      Expanded(
                        child: SmartRefresher(
                          enablePullDown: true,
                          header: WaterDropMaterialHeader(
                            backgroundColor: appBarColor.withOpacity(
                                0.8), //Theme.of(context).primaryColor,
                          ),

                          controller: _listRefreshController,
                          onRefresh: () {
                            print("Refresh");
                            setState(() {
                              notificationsCubit!.notifications = [];
                            });
                            _listRefreshController.refreshCompleted();
                          },
                          // onLoading: _onLoading,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: notificationsCubit!.notifications.map(
                              (e) {
                                print(e);
                                return NotificationTile(appNotification: e);
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is NotificationsError) {
              return Center(child: Text(state.error));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class NotificationTile extends StatefulWidget {
  AppNotification appNotification;

  NotificationTile({Key? key, required this.appNotification}) : super(key: key);

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.appNotification.read = true;
        Navigator.pushNamed(
          context,
          NOTIFICATION_DETAIL,
          arguments: {
            "notificationObj": widget.appNotification,
            "timeRecieved": _notificationInterval(widget.appNotification.time)
          },
        ).then((_) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        color: widget.appNotification.read
            ? Colors.white
            : Color.fromARGB(255, 218, 233, 250),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0x332c2b2b).withOpacity(0.15)))),
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.appNotification.title,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Spacer(),
                  Text(
                    widget.appNotification.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    _notificationInterval(widget.appNotification.time),
                    style: TextStyle(
                      color: Color(0xff838a8d),
                      fontWeight: FontWeight.bold,
                      // fontSize: 15,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            );
          },
        ), //
      ),
    );
  }

  String _notificationInterval(DateTime notificationTime) {
    int seconds = DateTime.now().difference(notificationTime).inSeconds;

    String timeInterval = "";

    if (seconds < 60) {
      timeInterval = "$seconds sec";
    } else if (seconds / 60 < 60) {
      timeInterval = "${(seconds / 60).floor()} min";
    } else if (seconds / 3600 < 24) {
      timeInterval = "${(seconds / 3600).floor()} hrs";
    } else {
      timeInterval =
          "${notificationTime.day}-${notificationTime.month}-${notificationTime.year}";
    }

    return timeInterval;
  }
}
