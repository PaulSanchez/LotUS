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

  # Construct a distribution object with the specified vectors of x
  # and p_values.  Both arrays must be the same length, the probabilities
  # must sum to 1, and all p-values must be between 0 and 1.  Raises a
  # RuntimeException if any of these preconditions is violated.
  def initialize(x, p_values)
    raise "Array lengths must be the same" if x.length != p_values.length
    total_prob = 0.0
    p_values.each do |p|
      raise "p_values must be between 0.0 and 1.0" if p < 0.0 || p > 1.0 
      total_prob += p
    end
    raise "p-values don't sum to one." if (1.0 - total_prob).abs > 1E-12
    # freezing makes the object immutable, i.e., you can't alter @x and
    # @p after they've been validated, despite having access to their
    # references via attr_reader.
    (@x = x.clone).freeze
    (@p = p_values.clone).freeze
    @mean = E()
    square = lambda {|value| value * value}
    @variance = E(square) - square[@mean]
  end

  # Implements "Law of the Unconcious Statistician" expectation
  # calculation of a function g(X) for the distribution.  If no
  # function g is supplied, it defaults to X, i.e., it calculates
  # E[X], the mean of the distribution.
  def E(g = lambda {|x| x})   # default function is x itself, yielding E[X]
    result = 0.0
    x.each_index {|i| result += g[@x[i]] * @p[i]}
    result
  end

end
