# Bloom Filter

A simple and efficient Dart implementation of a Bloom filter, a space-efficient probabilistic data structure used to test whether an element is a member of a set.

## Features

- Customizable false positive probability
- Efficient space usage
- Fast element insertion and querying
- Serialization and deserialization support

## Installation

Add the `serializable_bloom_filter` package to your `pubspec.yaml` file:

```yaml
dependencies:
  serializable_bloom_filter: ^1.0.0
```

Then run `dart pub get` to install the package.

## Usage

Import the `serializable_bloom_filter.dart` file and create a new `BloomFilter` object with the desired false positive probability and number of items you expect to insert:

```dart
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
  print(bloomFilter.contains("Charlie")); // false (might be true due to false positive)
}
```

## Serialization and Deserialization

You can serialize the Bloom filter's bit array for storage and later retrieve it:

```dart
import 'package:serializable_bloom_filter/serializable_bloom_filter.dart';

void main() {
  BloomFilter bloomFilter =
      BloomFilter(falsePositiveProbability: 0.01, numItems: 100);
  bloomFilter.add("Alice");
  bloomFilter.add("Bob");

  // Serialize the Bloom filter's bit array to a byte array
  List<int> byteArray = bloomFilter.serialize();
  int numHashFunctions = bloomFilter.numHashFunctions;

  // Save numHashFunctions and the byte array to a file or database, etc.
  // ...

  // Load numHashFunctions and the byte array from a file or database, etc.
  // ...

  // Deserialize the byte array back to the Bloom filter's bit array
  final loadedBloomFilter = BloomFilter.fromNumHashFunctionsAndByteArray(
      numHashFunctions: numHashFunctions, byteArray: byteArray);

  print(loadedBloomFilter.contains("Alice")); // true
  print(loadedBloomFilter.contains("Bob")); // true
  print(loadedBloomFilter
      .contains("Charlie")); // false (might be true due to false positive)
}
```
