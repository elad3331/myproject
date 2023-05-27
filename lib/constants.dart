import 'dart:collection';

import 'package:flutter/material.dart';

const int minUserNameLength = 6;
const int minPasswordLength = 8;
var globalUserName = "";
List<String> globalChatUsers = [];
Map<String, Queue<String>> chatQueues = {};
BuildContext? currentContext = null;
const String key = "elad";
var cities = ["ABU JUWEI'ID"];
