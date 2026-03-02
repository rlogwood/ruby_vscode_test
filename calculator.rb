# frozen_string_literal: true

# This is a simple calculator
class Calculator
  def add(a, b)
    a + b
  end
end

c = Calculator.new
print(c.add(10, 10))
