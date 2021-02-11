import 'dart:io' show Platform;
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unlimted_demo/model/contact.dart';

class PhoneNumberContacts {
  Future<bool> _askPermissions() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  Future<List<ContactUser>> getAllContacts() async {
    List<ContactUser> contactUsers = [];
    bool getPermission = false;
    if (Platform.isAndroid) {
      getPermission = await _askPermissions();
    }
    if (getPermission || Platform.isIOS) {
      var contacts = (await ContactsService.getContacts(
        withThumbnails: false,
      ))
          .toList();
      for (int i = 0; i < contacts.length; i++) {
        var phoneNumbers = contacts[i].phones;

        List<String> userPhoneNumbers = [];
        for (var item in phoneNumbers) {
          userPhoneNumbers.add(item.value);
        }

        contactUsers.add(ContactUser(
            displayName: contacts[i].displayName,
            phoneNumber: userPhoneNumbers));
      }
    }

    return contactUsers;
  }

  void addContacts(
      {String firstName, String lastName, String phoneNumber}) async {
    Contact contact = Contact(
        givenName: firstName,
        familyName: lastName,
        phones: [Item(label: 'mobile', value: phoneNumber)]);
    await ContactsService.addContact(contact);
  }
}
