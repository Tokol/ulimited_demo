import 'package:flutter/foundation.dart';
import 'package:unlimted_demo/model/contact.dart';
import 'package:unlimted_demo/services/service_contact.dart';

class ContactTask extends ChangeNotifier {
  PhoneNumberContacts phoneContactsService = PhoneNumberContacts();
  List<ContactUser> _contactUser = [];

  Future<List<ContactUser>> getAllContacts() async {
    _contactUser = await phoneContactsService.getAllContacts();
    notifyListeners();
    return _contactUser;
  }

  void addNewContact(
      {String firstName, String lastName, String phoneNumber}) async {
    await phoneContactsService.addContacts(
        firstName: firstName, lastName: lastName, phoneNumber: phoneNumber);
    await getAllContacts();
  }
}
