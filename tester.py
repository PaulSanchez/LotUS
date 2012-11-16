#!/usr/bin/env python

from distribution import Distribution
import math

def test_distribution(x, p):
  print "For x =", x, "and p =", p
  try:
    d = Distribution(x, p)
    print "E[X] =", d.mean
    print "E[X**2] =", d.E(lambda value: value * value)
    print "E[ln(X)] =", d.E(lambda value: math.log(value))
    print "Var[X] =", d.variance, '\n'
  except Exception, my_error:
    print my_error.message, '\n'

def main():
  test_distribution([1, 2, 3, 4], [0.4, 0.3, 0.2, 0.1])
  test_distribution([1, 2, 3, 4], [0.41, 0.3, 0.2, 0.1])
  test_distribution([1, 2, 3, 4, 5], [0.4, 0.3, 0.2, 0.1])
  test_distribution([1, 2, 3, 4], [1.4, 0.3, 0.2, 0.1])  
  p_die = 1.0 / 6.0
  test_distribution([1, 2, 3, 4, 5, 6], [p_die] * 6)
  test_distribution([1, 3, 4, 5, 6],
    [p_die, p_die, p_die, 2.0 * p_die, p_die])
  return 0
    
if __name__ == '__main__':
  main()
