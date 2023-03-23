import 'package:chatex/backend/database/contacts.dart';
import 'package:chatex/backend/database/permissions.dart';
import 'package:chatex/theme.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../size.dart';
import 'contact_card.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final box = GetStorage();
  List<Users> users = [
    Users("Divyesh Shah", "", 3452603425),
    Users("Meet Shrimankar", "", 3452603425),
    Users("Arun Warrier", "", 3452603425),
  ];

  late Permissions permissions;

  @override
  void initState() {
    permissions = Permissions(context);
    super.initState();
  }

  void selectContact(String name, String photoUrl, List<Item> contacts) {
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
                      GestureDetector(
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
                            setState(() {
                              users.add(Users(name, photoUrl, int.parse(num)));
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          contacts[index].value!,
                          style: TextStyle(
                            color: pallete.primaryDark,
                            fontSize: getHeight(14),
                          ),
                        ),
                      ),
                      SizedBox(height: getHeight(10)),
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
  Widget build(BuildContext context) {
    Pallete pallete = Pallete(context);
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () async {
          bool permissionGranted = await permissions.askPermissions();
          if (permissionGranted) {
            Contact? contact = await ContactsService.openDeviceContactPicker();
            selectContact(contact!.displayName!, "", contact.phones!);
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
            )
          ],
        ),
      ),
    );
  }
}
