require File.expand_path('../mamal', __FILE__)

class Dog < Animal
  include Mamal

  def info
    puts "I #{make_noise}."
    super
  end

  def make_noise
    'bark "Woof woof"'
  end
end