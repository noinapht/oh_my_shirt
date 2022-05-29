// To parse this JSON data, do
//
//     final omsUser = omsUserFromJson(jsonString);

import 'dart:convert';

OmsUser omsUserFromJson(String str) => OmsUser.fromJson(json.decode(str));

String omsUserToJson(OmsUser data) => json.encode(data.toJson());

class OmsUser {
    OmsUser({
        this.uid,
        this.displayName,
        this.email,
        this.photoURL,
        this.coin,
        this.onGoing,
    });

    String uid;
    String displayName;
    String email;
    String photoURL;
    int coin;
    OnGoing onGoing;

    factory OmsUser.fromJson(Map<String, dynamic> json) => OmsUser(
        uid: json["uid"] == null ? null : json["uid"],
        displayName: json["displayName"] == null ? null : json["displayName"],
        email: json["email"] == null ? null : json["email"],
        photoURL: json["photoURL"] == null ? null : json["photoURL"],
        coin: json["coin"] == null ? null : json["coin"],
        onGoing: json["onGoing"] == null ? null : OnGoing.fromJson(json["onGoing"]),
    );

    Map<String, dynamic> toJson() => {
        "uid": uid == null ? null : uid,
        "displayName": displayName == null ? null : displayName,
        "email": email == null ? null : email,
        "photoURL": photoURL == null ? null : photoURL,
        "coin": coin == null ? null : coin,
        "onGoing": onGoing == null ? null : onGoing.toJson(),
    };
}

class OnGoing {
    OnGoing({
        this.machineId,
        this.process,
        this.time,
        this.cost,
        this.startTime,
        this.endTime,
    });

    String machineId;
    String process;
    int time;
    int cost;
    dynamic startTime;
    dynamic endTime;

    factory OnGoing.fromJson(Map<String, dynamic> json) => OnGoing(
        machineId: json["machineId"] == null ? null : json["machineId"],
        process: json["process"] == null ? null : json["process"],
        time: json["time"] == null ? null : json["time"],
        cost: json["cost"] == null ? null : json["cost"],
        startTime: json["startTime"],
        endTime: json["endTime"],
    );

    Map<String, dynamic> toJson() => {
        "machineId": machineId == null ? null : machineId,
        "process": process == null ? null : process,
        "time": time == null ? null : time,
        "cost": cost == null ? null : cost,
        "startTime": startTime,
        "endTime": endTime,
    };
}
