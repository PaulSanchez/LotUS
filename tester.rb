#!/usr/bin/env ruby -w

require_relative './distribution.rb'
require_relative './rational_to_s.rb'     # to get desired .to_s behavior

def test_distribution(x, p)
  puts 'For x = ' + x.inspect + ' and p = ' + p.inspect
  begin
    d = RandomVariable.new(x, p)
    printf "E[X] = %s\n", d.mean
    square = ->(number) { number * number }
    e_sqr = d.E(square)
    printf "E[X**2] = %s\n", e_sqr
    printf "E[ln(X)] = %s\n", d.E(->(number) { Math.log number })
    printf "Var[X] = E[X**2] - E[X]**2 = %s - %s = %s\n\n",
           e_sqr, square[d.mean], d.variance
  rescue RuntimeError => my_error
    puts my_error.message
    puts
  end
  d
end

# Suffix 'r' makes value a Rational literal
test_distribution([1, 2, 3, 4], [0.4r, 0.3r, 0.2r, 0.1r])
test_distribution([1, 2, 3, 4], [0.41r, 0.3r, 0.2r, 0.1r])
test_distribution([1, 2, 3, 4, 5], [0.4r, 0.3r, 0.2r, 0.1r])
test_distribution([1, 2, 3, 4], [1.4r, 0.3r, 0.2r, 0.1r])
p_die = 1 / 6r
test_distribution([1, 2, 3, 4, 5, 6], [p_die] * 6)
test_distribution([1, 3, 4, 5, 6], [p_die, p_die, p_die, 2 * p_die, p_die])
test_distribution(['a', 'b', 'c', 'c'], [0.4r, 0.3r, 0.2r, 0.1r])
