#!/usr/bin/env ruby -w

# Represent a discrete random variable in terms of its probability
# distribution, given as a pair of matched-length arrays.
class RandomVariable
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
    unless x_set.length == p_set.length
      fail 'x_set and p_set must be the same length'
    end
    total_prob = 0r
    @p = {} # use a hash to store p[x]
    @x = []
    x_set.zip(p_set).each do |x_val, p_val|
      fail 'Random Variables must be numeric' unless x_val.is_a? Numeric
      @x << x_val.to_r
      p_val = p_val.to_r
      fail 'P-values must be positive numbers' unless p_val > 0
      @p[@x.last] = p_val
      total_prob += p_val
    end
    fail "P-values don't sum to one." unless total_prob == 1
    # Now that @x and @p have been validated, freeze'ing makes them immutable
    @x.sort!.freeze
    @p.freeze
    @mean = E()
    square = ->(value) { value * value }
    @variance = E(square) - square[@mean]
  end

  # Implements "Law of the Unconcious Statistician" expectation
  # calculation of a function g(X) for the distribution.  If no
  # function g is supplied, it defaults to X, i.e., it calculates
  # E[X], the mean of the distribution.
  def E(g = ->(value) { value }) # default function is x itself ==> E[X]
    @x.map { |x| g[x] * @p[x] }.inject(:+) # sum g * p for all x
  end
end
