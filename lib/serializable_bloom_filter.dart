/// A bloom filter is a probabilistic data structure that can be used to test
/// whether an element is a member of a set. False positives are possible, but
/// false negatives are not.
///
/// The desired false positive probability can be specified when creating the
/// filter. The number of items that will be added to the filter must also be
/// specified. The optimal size of the filter and the number of hash functions
/// to use are calculated automatically.
library serialiable_bloom_filter;

export 'src/serializable_bloom_filter_base.dart';
