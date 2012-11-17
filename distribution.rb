#!/usr/bin/env ruby -w

# Represent a discrete probability distribution as a pair of
# matched-length arrays.
class Distribution
  
  # The array of values - attr_reader gives a getter but not a setter
  attr_reader :x
  # The array of probabilities - attr_reader gives a getter but not a setter
  attr_reader :p
  # Cached value for mean of the distribution
  attr_reader :mean
  # Cached value for variance of the distribution
  attr_reader :variance

  # Construct a distribution object with the specified vectors of x_set
  # and p_set.  Both arrays must be the same length, the probabilities
  # must sum to 1, and all p-values must be between 0 and 1.  Raises a
  # RuntimeException if any of these preconditions is violated.
  def initialize(x_set, p_set)
    raise "Array lengths must be the same" if x_set.length != p_set.length
    total_prob = 0.0
    @p = {}   # use a hash to store p[x]
    x_set.each_index do |i|
      raise "Require 0.0 <= p <= 1.0" if p_set[i] < 0.0 || p_set[i] > 1.0
      @p[x_set[i]] = p_set[i]
      total_prob += p_set[i]
    end
    raise "P-values don't sum to one." if (1.0 - total_prob).abs > 1E-12
    # freezing makes the object immutable, i.e., you can't alter @x and
    # @p after they've been validated, despite having access to their
    # references via attr_reader.
    @x = x_set.clone.sort.freeze
    @p.freeze
    @mean = E()
    square = lambda {|value| value * value}
    @variance = E(square) - square[@mean]
  end

  # Implements "Law of the Unconcious Statistician" expectation
  # calculation of a function g(X) for the distribution.  If no
  # function g is supplied, it defaults to X, i.e., it calculates
  # E[X], the mean of the distribution.
  def E(g = lambda {|value| value})   # default function is x itself ==> E[X]
    @x.inject(0.0) {|sum, current_x| sum + (g[current_x] * @p[current_x])}
  end

end
