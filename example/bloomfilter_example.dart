import 'package:serializable_bloom_filter/serializable_bloom_filter.dart';

void main() {
  // Create a new Bloom filter with a false positive probability of 1% and an expected number of items of 100
  BloomFilter bloomFilter =
      BloomFilter(falsePositiveProbability: 0.01, numItems: 100);

  // Add items to the filter
  bloomFilter.add("Alice");
  bloomFilter.add("Bob");

  // Check if an item is in the filter
  print(bloomFilter.contains("Alice")); // true
  print(bloomFilter.contains("Bob")); // true
  print(bloomFilter
      .contains("Charlie")); // false (might be true due to false positive)
}
