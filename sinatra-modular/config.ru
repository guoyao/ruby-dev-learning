require 'sinatra/base'

require './main'
require './app/controllers/songs_controller'

#Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

map('/') { run Website }
map('/songs') { run SongsController }