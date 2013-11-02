require 'sinatra/base'

require './main'
require './app/controllers/songs_controller'

map('/') { run Website }
map('/songs') { run SongsController }