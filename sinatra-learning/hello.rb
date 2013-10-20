require 'sinatra'
require 'sass'
require 'slim'
require 'sinatra/reloader' if development?
require_relative 'app/models/song'

#get('/main.css') { scss :main }
get('**/main.css') { scss :main }

get '/' do
  @title = "index"
  slim :index
end

get '/about' do
  slim :about
end

get '/songs' do
  @songs = Song.all
  slim :songs
end

get '/songs/new' do
  @song = Song.new
  slim :new_song
end

get '/songs/:id' do
  @song = Song.get(params[:id])
  slim :show_song
end

post '/songs' do
  song = Song.create(params[:song])
  redirect to("/songs/#{song.id}")
end

get '/songs/:id/edit' do
  @song = Song.get(params[:id])
  slim :edit_song
end

put '/songs/:id' do
  song = Song.get(params[:id])
  song.update(params[:song])
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  Song.get(params[:id]).destroy
  redirect to('/songs')
end

not_found do
  slim :not_found
end
