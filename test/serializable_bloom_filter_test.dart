import 'dart:math';

import 'package:serializable_bloom_filter/serializable_bloom_filter.dart';
import 'package:test/test.dart';

void main() {
  group('BloomFilter tests', () {
    final bloomFilter =
        BloomFilter(falsePositiveProbability: 0.001, numItems: 1000);

    test('returns true when item exists', () {
      bloomFilter.add('test');
      expect(bloomFilter.contains('test'), true);
    });

    test('returns false when item does not exist', () {
      expect(bloomFilter.contains('non existent'), false);
    });

    test('false positive rate matches expectation', () {
      final random = Random(31415);
      final numItems = 1000;
      final falsePositiveRate = 0.01;
      // ignore: prefer_function_declarations_over_variables
      final singleTest = () {
        final filter = BloomFilter(
            falsePositiveProbability: falsePositiveRate, numItems: numItems);
        for (var i = 0; i < numItems; i++) {
          filter.add(random.nextInt(1000000).toString());
        }
        return filter.contains(random.nextInt(1000000).toString());
      };
      final numTests = 1000;
      final numFalsePositives = List.generate(numTests, (_) => singleTest())
          .where((element) => element)
          .length;
      final testedFalsePositiveRate = numFalsePositives / numTests;
      expect(
        testedFalsePositiveRate.abs(),
        lessThan(falsePositiveRate * 5 /* margin of error */),
      );
    });
  });
}
