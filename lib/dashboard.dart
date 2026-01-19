import "dart:async";

import "package:flutter/material.dart";

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String debouncedQuery = "";

  final List<String> fruits = <String>[
    "Apple",
    "Banana",
    "Orange",
    "Mango",
    "Pineapple",
    "Grapes",
    "Strawberry",
    "Watermelon",
    "Papaya",
    "Guava",
    "Kiwi",
    "Peach",
    "Plum",
    "Cherry",
    "Pear",
    "Pomegranate",
    "Lemon",
    "Lychee",
    "Blueberry",
    "Raspberry",
  ];

  Timer timer = Timer(Duration.zero, () {});

  bool isLoading = false;

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("debounce_sample")),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            searchWidget(),

            if (isLoading) loadingIndicator(),

            Expanded(child: listViewWidget()),
          ],
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (String value) {
          isLoading = true;
          setState(() {});

          debounce(() {
            debouncedQuery = value;

            isLoading = false;
            setState(() {});
          });
        },
        decoration: const InputDecoration(
          labelText: "Search",
          hintText: "Type here",
        ),
      ),
    );
  }

  Widget loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: LinearProgressIndicator(),
    );
  }

  Widget listViewWidget() {
    final List<String> filteredFruits = searchFruits();

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ScrollPhysics(),
      itemCount: filteredFruits.length,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 0, indent: 16, endIndent: 16);
      },
      itemBuilder: (BuildContext context, int index) {
        final String item = filteredFruits[index];

        return ListTile(dense: true, title: Text(item));
      },
    );
  }

  void debounce(VoidCallback callback) {
    if (timer.isActive) {
      timer.cancel();
    }

    timer = Timer(const Duration(seconds: 1), callback);

    return;
  }

  List<String> searchFruits() {
    final String searchQuery = debouncedQuery.trim().toLowerCase();

    return searchQuery.isEmpty
        ? fruits
        : fruits.where((String e) {
            final String item = e.trim().toLowerCase();

            return item.contains(searchQuery);
          }).toList();
  }
}
