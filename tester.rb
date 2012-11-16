#!/usr/bin/env ruby -w

require './distribution.rb'

def test_distribution(x, p)
  puts "For x = " + x.inspect + " and p = " + p.inspect
  begin
    d = Distribution.new(x, p)
    printf "E[X] = %f\n", d.mean
    printf "E[X**2] = %f\n", d.E(lambda {|value| value * value})
    printf "E[ln(X)] = %f\n", d.E(lambda {|value| Math.log(value)})
    printf "Var[X] = %f\n\n", d.variance
  rescue RuntimeError => my_error
    puts my_error.message
    puts
  end
  return d
end

test_distribution([1, 2, 3, 4], [0.4, 0.3, 0.2, 0.1])
test_distribution([1, 2, 3, 4], [0.41, 0.3, 0.2, 0.1])
test_distribution([1, 2, 3, 4, 5], [0.4, 0.3, 0.2, 0.1])
test_distribution([1, 2, 3, 4], [1.4, 0.3, 0.2, 0.1])
p_die = 1.0 / 6.0
test_distribution([1, 2, 3, 4, 5, 6], [p_die] * 6)
test_distribution([1, 3, 4, 5, 6],
  [p_die, p_die, p_die, 2.0 * p_die, p_die])
