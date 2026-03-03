# frozen_string_literal: true
# typed: true

# NOTE: sorbet requires the `# typed: true` signature at the top of the file to enable type checking.

# This is a simple calculator
class Calculator
  #: (Integer, Integer) -> Integer
  def add(a, b)
    a + b
  end
end

c = Calculator.new
print(c.add(10, 10))
print(c.add(5, 15))

c.add(5, 10)
