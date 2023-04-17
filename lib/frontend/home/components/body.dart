import 'dart:async';

import 'package:chatex/backend/api/api.dart';
import 'package:chatex/backend/database/users.dart';
import 'package:chatex/backend/database/permissions.dart';
import 'package:chatex/frontend/components/primary_btn.dart';
import 'package:chatex/theme.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';

import '../../../size.dart';
import 'contact_card.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final box = GetStorage();
  List<User> users = [];

  late Permissions permissions;
  late Timer timer;

  void getContacts() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print("Getting contacts...");
      Api.registerUser(box.read("number").toString()).then((value) {
        setState(() {
          users = value;
        });
      });
    });
  }

  @override
  void initState() {
    permissions = Permissions(context);
    Api.registerUser(box.read("number").toString()).then((value) {
      setState(() {
        users = value;
      });
    });
    getContacts();
    super.initState();
  }

  void checkIfUserExists(String name, int number) async {
    int current = box.read("number");
    String exists = await Api.addContact(current.toString(), box.read("name"),
        name, number.toString(), (current + number).toString());
    if (exists == "True") {
      print("Exists");
      setState(() {
        users.add(User(name, number));
      });
    } else {
      print("Does not exists");
      sendInvite(name);
    }
  }

  void sendInvite(String name) {
    Pallete pallete = Pallete(context);

    AlertDialog dialog = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      backgroundColor: pallete.background,
      title: Row(
        children: [
          Expanded(
            child: Text(
              "Share this app!",
              style: TextStyle(
                color: pallete.primaryDark,
                fontSize: getHeight(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: getWidth(10)),
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedRotation(
              turns: 1 / 8,
              duration: const Duration(seconds: 1),
              child: Icon(
                Icons.add,
                color: Theme.of(context).primaryColorDark,
                size: getHeight(26),
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: getWidth(160),
        height: getWidth(140),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "It looks like $name has not registered with ChatEx yet,",
              style: TextStyle(
                color: pallete.primaryDark,
                fontSize: getHeight(14),
              ),
            ),
            Text(
              "Share this app with him to start chatting!",
              style: TextStyle(
                color: pallete.primaryDark,
                fontSize: getHeight(14),
              ),
            ),
            SizedBox(height: getHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(getWidth(8)),
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(getWidth(8)),
                            border: Border.all(color: const Color(0xFF32426B))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(20),
                              vertical: getHeight(10)),
                          child: Text(
                            "No thanks",
                            style: TextStyle(
                              color: pallete.primaryDark,
                              fontSize: getHeight(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getWidth(20)),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Share.share("Check out ChatEx app now!",
                            subject: "Look what I found!");
                      },
                      borderRadius: BorderRadius.circular(getWidth(8)),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: const Color(0xFF32426B),
                          borderRadius: BorderRadius.circular(getWidth(8)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(20),
                              vertical: getHeight(10)),
                          child: Text(
                            "Of course",
                            style: TextStyle(
                              color: pallete.primaryDark,
                              fontSize: getHeight(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  void selectContact(String name, List<Item> contacts) {
    Pallete pallete = Pallete(context);

    AlertDialog dialog = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      backgroundColor: pallete.background,
      title: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: pallete.primaryDark,
                fontSize: getHeight(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: getWidth(10)),
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedRotation(
              turns: 1 / 8,
              duration: const Duration(seconds: 1),
              child: Icon(
                Icons.add,
                color: Theme.of(context).primaryColorDark,
                size: getHeight(26),
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: getWidth(120),
        height: contacts.isEmpty ? getHeight(40) : getHeight(160),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contacts.isEmpty ? "No contacts found!" : "Select a contact",
              style: TextStyle(
                color: pallete.primaryDark,
                fontSize: getHeight(14),
              ),
            ),
            if (contacts.isNotEmpty) SizedBox(height: getHeight(20)),
            if (contacts.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: contacts.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          String num = contacts[index].value!;
                          num = num.replaceAll(" ", "");
                          num = num.replaceAll("+91", "");
                          bool alreadyContains = false;
                          for (var user in users) {
                            if (user.number == int.parse(num)) {
                              alreadyContains = true;
                              break;
                            }
                          }
                          if (!alreadyContains) {
                            checkIfUserExists(name, int.parse(num));
                          }
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF32426B)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Text(
                              contacts[index].value!,
                              style: TextStyle(
                                color: pallete.primaryDark,
                                fontSize: getHeight(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: getHeight(14)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Pallete pallete = Pallete(context);
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () async {
          bool permissionGranted = await permissions.askPermissions();
          if (permissionGranted) {
            Contact? contact = await ContactsService.openDeviceContactPicker()
                .catchError((error) {
              print("Operation cancelled by user");
            });
            if (contact != null) {
              selectContact(contact.displayName!, contact.phones!);
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.only(right: getWidth(10), bottom: getWidth(10)),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: pallete.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.add_ic_call_rounded,
                color: Color(0xff18202D),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getHeight(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
              child: Text(
                "Messages",
                style: TextStyle(
                  color: pallete.primaryDark,
                  fontSize: getHeight(22),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: getHeight(5)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
              child: Text(
                box.read("name").toUpperCase(),
                style: TextStyle(
                  color: pallete.primaryLight,
                  fontSize: getHeight(14),
                  letterSpacing: 2,
                ),
              ),
            ),
            SizedBox(height: getHeight(40)),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF292F3F),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(getWidth(20)),
                    topRight: Radius.circular(getWidth(20)),
                  ),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) => ContactCard(
                      index: index, contacts: users, pallete: pallete),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
