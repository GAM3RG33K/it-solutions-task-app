import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "IT Solutions Task",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("IT Solutions Task"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Dock(
                  items: const [
                    Icons.person,
                    Icons.message,
                    Icons.call,
                    Icons.camera,
                    Icons.photo,
                  ],
                  builder: (e) {
                    return Container(
                      constraints: const BoxConstraints(minWidth: 48),
                      height: 48,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors
                            .primaries[e.hashCode % Colors.primaries.length],
                      ),
                      child: Center(child: Icon(e, color: Colors.white)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late List<T> _items;

  @override
  void initState() {
    _items = widget.items.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      height: 100,
      constraints: const BoxConstraints(minWidth: 48),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: ReorderableListView(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          shrinkWrap: true,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = _items.removeAt(oldIndex);
              _items.insert(newIndex, item);
            });
          },
          proxyDecorator: (child, index, animation) {
            var scale = animation.value + 0.5;
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          children: _items
              .asMap()
              .entries
              .map(
                (entry) => Padding(
                  key: ValueKey(entry.key),
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ReorderableDragStartListener(
                      key: ValueKey(entry.key),
                      index: entry.key,
                      child: SizedBox(
                        height: 72,
                        width: 72,
                        child: widget.builder(entry.value),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
