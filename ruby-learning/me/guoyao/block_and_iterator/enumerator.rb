triangular_numbers = Enumerator.new do |yielder|
  number = 0
  count = 1
  loop do
    number += count
    count += 1
    yielder.yield number
  end
end

p triangular_numbers.first(5)

def infinite_select(enum, &block)
  Enumerator.new do |yielder|
    enum.each do |value|
      yielder.yield(value) if block.call(value)
    end
  end
end

p infinite_select(triangular_numbers) { |val| val % 10 == 0 }.first(5)

class Enumerator
  def infinite_select(&block)
    Enumerator.new do |yielder|
      self.each do |value|
        yielder.yield(value) if block.call(value)
      end
    end
  end
end

p triangular_numbers
  .infinite_select { |val| val % 10 == 0 }
  .infinite_select { |val| val.to_s =~ /3/ }
  .first(5)

def Integer.all
  Enumerator.new do |yielder, n: 0|
    loop { yielder.yield(n += 1) }
  end.lazy
end

p Integer.all.first(10)
p Integer.all.select { |i| (i % 3).zero? }.first(10)

def palindrome?(n)
  n = n.to_s
  n == n.reverse
end

p Integer.all.select { |i| (i % 3).zero? }.select { |i| palindrome?(i) }.first(10)

multiple_of_three = Integer.all.select { |i| (i % 3).zero?}
p multiple_of_three.first(10)
m3_palindrome = multiple_of_three.select { |i| palindrome?(i)}
p m3_palindrome.first(10)

multiple_of_three = -> n { (n % 3).zero? }
palindrome = -> n { n = n.to_s; n == n.reverse}
p Integer.all.select(&multiple_of_three).select(&palindrome).first(10)

def Fixnum.all
  start = 0
  Enumerator.new do |yielder|
    loop do
      yielder.yield (start += 1)
    end
  end
end

p Fixnum.all.first(5)
