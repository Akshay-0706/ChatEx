import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  final BuildContext context;
  Permissions(this.context);

  Future<bool> askPermissions() async {
    PermissionStatus permissionStatus = await getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      handleInvalidPermissions(permissionStatus);
      return false;
    }
  }

  Future<PermissionStatus> getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text("Access to contact data denied"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text("Please allow contact permission from settings"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
