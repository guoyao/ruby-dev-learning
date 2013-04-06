require File.expand_path('../me/guoyao/models/animal', __FILE__)
require File.expand_path('../me/guoyao/models/dog', __FILE__)

lassie = Dog.new 'Lassie'
lassie.info
p Dog.ancestors