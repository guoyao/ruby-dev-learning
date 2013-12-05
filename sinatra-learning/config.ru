require './main'
DataMapper.auto_migrate!
run Sinatra::Application