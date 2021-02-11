import 'package:call_log/call_log.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:unlimted_demo/model/call_log.dart';
import 'dart:io' show Platform;

class CallLogTask extends ChangeNotifier {
  Future<List<PhoneCallLog>> getCallLog() async {
    List<PhoneCallLog> _phoneCallLog = [];
    if (Platform.isIOS) {
      return _phoneCallLog;
    }

    try {
      Iterable<CallLogEntry> entries = await CallLog.get();
      for (var item in entries) {
        _phoneCallLog.add(PhoneCallLog(
            name: item.name,
            duration: "${item.duration.toString()} seconds",
            timeStamp: convertStampToDateTime(item.timestamp),
            callType: callType(item.callType),
            phoneNumber: item.number));
      }

      return _phoneCallLog;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  String convertStampToDateTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    var formattedDate = DateFormat.yMMMd().format(date);
    var timeFormat = new DateFormat('hh:mm:ss aa');

    return ('${timeFormat.format(date)}-$formattedDate');
  }

  String callType(CallType callType) {
    switch (callType) {
      case CallType.incoming:
        return "Incoming";
        break;

      case CallType.outgoing:
        return "OutGoing";
        break;

      case CallType.unknown:
        return "Unknown";
        break;

      case CallType.missed:
        return "Missed Call";
        break;

      case CallType.rejected:
        return "Rejected";
        break;

      case CallType.blocked:
        return "Blocked";
        break;

      case CallType.voiceMail:
        return "Voice mail";
        break;

      case CallType.answeredExternally:
        return "Answered Externally";
        break;

      default:
        return "Unknown";
        break;
    }
  }
}
