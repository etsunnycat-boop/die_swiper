import 'package:die_swiper/die_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'autoplay:false does not start periodic timer after controller.next()',
    (tester) async {
      final controller = SwiperController();
      var lastIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Swiper(
            controller: controller,
            autoplay: false,
            autoplayDelay: 10,
            duration: 1,
            onIndexChanged: (index) {
              lastIndex = index;
            },
            itemCount: 10,
            itemBuilder: (context, index) => Text('item-$index'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(lastIndex, 0);

      await controller.next(animation: false);
      await tester.pumpAndSettle();
      expect(lastIndex, 1);

      // If a periodic autoplay timer was accidentally started by needToResetTimer,
      // the swiper would continue to advance to index 2 after autoplayDelay.
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      expect(lastIndex, 1);
    },
  );
}
