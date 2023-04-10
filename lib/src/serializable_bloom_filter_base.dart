// Copyright (c) 2023, FlutterFlow, Inc.
// All rights reserved. Use of this source code is governed by an
// MIT license that can be found in the LICENSE file.

import 'dart:math';
import 'dart:typed_data';

/// A bloom filter is a probabilistic data structure that can be used to test
/// whether an element is a member of a set. False positives are possible, but
/// false negatives are not.
///
/// The desired false positive probability can be specified when creating the
/// filter. The number of items that will be added to the filter must also be
/// specified. The optimal size of the filter and the number of hash functions
/// to use are calculated automatically.
class BloomFilter {
  late int _size;
  late int _numHashFunctions;
  late Int32List _bitArray;

  BloomFilter({
    required double falsePositiveProbability,
    required int numItems,
  }) {
    if (falsePositiveProbability <= 0 || falsePositiveProbability >= 1) {
      throw ArgumentError(
          "False positive probability must be in range (0, 1).");
    }
    if (numItems <= 0) {
      throw ArgumentError("Number of items must be positive.");
    }

    _size = _calculateOptimalSize(falsePositiveProbability, numItems);
    _numHashFunctions = _calculateOptimalNumHashFunctions(_size, numItems);
    _bitArray = Int32List(_size);
  }

  // A static constructor for creating a bloom filter from a serialized
  // representation. This is useful for retrieving a bloom filter from a
  // database or receiving it over the network.
  BloomFilter.fromNumHashFunctionsAndByteArray({
    required int numHashFunctions,
    required List<int> byteArray,
  }) {
    if (numHashFunctions <= 0) {
      throw ArgumentError("Number of hash functions must be positive.");
    }
    if (byteArray.isEmpty) {
      throw ArgumentError("Bit array must not be empty.");
    }

    _bitArray = Int32List.view(Uint8List.fromList(byteArray).buffer);
    _size = _bitArray.length;
    _numHashFunctions = numHashFunctions;
  }

  int get size => _size;
  int get numHashFunctions => _numHashFunctions;

  /// Serialize the bloom filter. This is useful for storing the filter in a
  /// database or sending it over the network. It's important to store the
  /// number of hash functions used to create the filter.
  List<int> serialize() {
    return _bitArray.buffer.asUint8List();
  }

  // The following functions are based on:
  // https://en.wikipedia.org/wiki/Bloom_filter
  int _calculateOptimalSize(double p, int n) {
    return (-1 * (n * log(p)) / pow(log(2), 2)).ceil();
  }

  int _calculateOptimalNumHashFunctions(int m, int n) {
    return ((m / n) * log(2)).ceil();
  }

  /// Add an item to the bloom filter.
  void add(String item) {
    for (int i = 0; i < _numHashFunctions; i++) {
      int index = _hash(item, i);
      _bitArray[index] = 1;
    }
  }

  /// Check if an item is in the bloom filter. This may return false positives,
  /// but will never return false negatives. The false positive probability
  /// can be controlled when initializing the bloom filter.
  bool contains(String item) {
    for (int i = 0; i < _numHashFunctions; i++) {
      int index = _hash(item, i);
      if (_bitArray[index] == 0) {
        return false;
      }
    }
    return true;
  }

  int _hash(String item, int seed) {
    return '$item$seed'.hashCode % _size;
  }
}
