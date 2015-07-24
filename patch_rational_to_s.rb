module PatchRationalToS
  def to_s
    denominator == 1 ? numerator.to_s : super.to_s
  end
end

Rational.prepend PatchRationalToS
