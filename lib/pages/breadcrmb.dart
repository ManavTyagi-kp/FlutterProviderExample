import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 100,
            width: 1000,
            child: Consumer<BreadCrumbProvider>(
              builder: (context, value, child) {
                return Breadcrumbs(
                  breadCrumbs: value.item,
                );
              },
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/new');
            },
            child: const Text('Add new breadcrum'),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          TextButton(
            onPressed: () {
              context.read<BreadCrumbProvider>().reset();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class AddBreadcrum extends StatefulWidget {
  const AddBreadcrum({super.key});

  @override
  State<AddBreadcrum> createState() => _AddBreadcrumState();
}

class _AddBreadcrumState extends State<AddBreadcrum> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add BreadCrumb'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
                hintText: 'Enter new bread crumb here....'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = _controller.text;
              final breadCrumb = ActiveStatus(
                active: false,
                name: text,
              );
              context.read<BreadCrumbProvider>().add(breadCrumb);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class Breadcrumbs extends StatelessWidget {
  final UnmodifiableListView<ActiveStatus> breadCrumbs;
  const Breadcrumbs({super.key, required this.breadCrumbs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        title: const Text('BreadCrumb Viewer'),
      ),
      body: Wrap(
        children: breadCrumbs.map(
          (breadCrumbs) {
            return Text(
              breadCrumbs.title,
              style: TextStyle(
                color: breadCrumbs.active ? Colors.blue : Colors.black,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class ActiveStatus {
  bool active;
  String name;
  final String uuid;

  ActiveStatus({required this.active, required this.name})
      : uuid = const Uuid().v4();

  void activate() {
    active = true;
  }

  @override
  bool operator ==(covariant ActiveStatus other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  String get title => name + (active ? '>' : '');
}

class BreadCrumbProvider extends ChangeNotifier {
  final List<ActiveStatus> _items = [];
  UnmodifiableListView<ActiveStatus> get item => UnmodifiableListView(_items);

  void add(ActiveStatus activeStatus) {
    for (final item in _items) {
      item.activate();
    }
    _items.add(activeStatus);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}
