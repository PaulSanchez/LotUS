#!/usr/bin/env python
"""A simple class providing expectation and variance calculations for
discrete distributions."""

class Distribution(object):
  """Represent a discrete probability distribution as a pair of
  matched-length arrays.
  
  Public functions:
    E -- calculate the expected value of a function of the random
    variable, as per the law of the unconscious statistician.

    variance -- calculate the variance of the distribution.
  """

  def __init__(self, x, p_values):
    """Construct a Distribution object from the provided x and p_values lists.

    Arguments:
      x -- The x-values associated with the random variable.
      
      p_values -- The (synchronized) p-values associated with each x-value.

    Exceptions:
      Throws RuntimeError exceptions if the lists are of different lengths,
      if any of the p-values fall outside the range [0,1], or if the p-values
      do not total to 1.0.   
    """ 
    super(Distribution, self).__init__()
    if len(x) != len(p_values):
      raise RuntimeError("Array lengths must be the same")
    total_prob = 0.0
    for i in range(0, len(x)):
      if p_values[i] < 0.0 or p_values[i] > 1.0:
        raise RuntimeError("p_values must be between 0.0 and 1.0")
      total_prob += p_values[i]
    if abs(1.0 - total_prob) > 1E-12:
      raise RuntimeError("p_values don't sum to 1.0")
    self.x = tuple(x)
    self.p_values = tuple(p_values)

  def E(self, g = lambda x: x):
    """Return the expected value of g(X) for this distribution.

    Arguments:
      g -- A lambda representing the function to apply to the random
      variable X.  If no lambda is supplied it defaults to the function X,
      yielding E[X], the mean of the distribution.

    Returns:
      The expected value of g(X).   
    """ 
    result = 0.0
    for i in range(0, len(self.x)):
      result += g(self.x[i]) * self.p_values[i]
    return result

  def variance(self):
    """Return the variance of the distribution."""
    square = lambda value: value * value
    return self.E(square) - square(self.E())
