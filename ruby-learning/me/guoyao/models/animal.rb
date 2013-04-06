class Animal
  def initialize(name)
   @name = name
  end

  def info
    puts "I am #{self.class}"
    puts "My name is '#{@name}'"
  end
end