require 'slim'
require './app/controllers/application_controller'
require './app/models/song'

module SongHelpers
  def find_songs
    @songs = Song.all
  end

  def find_song
    Song.get(params[:id])
  end

  def create_song
    @song = Song.create(params[:song])
  end
end

class SongsController < ApplicationController
  helpers SongHelpers

  get '/' do
    find_songs
    slim :songs
  end

  get '/new' do
    protected!
    @song = Song.new
    slim :new_song
  end

  get '/:id' do
    @song = find_song
    slim :show_song
  end

  post '/' do
    protected!
    flash[:notice] = "Song successfully added" if create_song
    redirect to("/#{@song.id}")
  end

  get '/:id/edit' do
    protected!
    @song = find_song
    slim :edit_song
  end

  put '/:id' do
    protected!
    song = find_song
    flash[:notice] = "Song successfully updated" if song.update(params[:song])
    redirect to("/#{song.id}")
  end

  delete '/:id' do
    protected!
    flash[:notice] = "Song successfully deleted" if find_song.destroy
    redirect to('/')
  end

  post '/:id/like' do
    @song = find_song
    @song.likes = @song.likes.next
    @song.save
    redirect to"/#{@song.id}" unless request.xhr?
    slim :like, :layout => false
  end
end