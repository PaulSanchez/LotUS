#!/usr/bin/env python
"""A simple class with expectation calculations for discrete distributions."""
class Distribution(object):
  """Represent a discrete distribution as a pair of matched-length arrays.
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
      Throws RuntimeError exceptions for different length lists, if any
      p-values fall outside [0,1], or if the p-values don't sum to 1.0.
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
    self._x = tuple(x)
    self._p_values = tuple(p_values)
    self._mean = self.E()
    square = lambda value: value * value
    self._variance = self.E(square) - square(self.E())

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
    for i in range(0, len(self._x)):
      result += g(self._x[i]) * self._p_values[i]
    return result

  @property
  def mean(self):
    """Return the mean of the distribution."""
    return self._mean

  @property
  def variance(self):
    """Return the variance of the distribution."""
    return self._variance
