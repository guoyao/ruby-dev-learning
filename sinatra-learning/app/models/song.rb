require 'dm-core'
require 'dm-migrations'

class Song
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :lyrics, Text
  property :length, Integer
  property :released_on, Date
  property :likes, Integer, :default => 0

  def released_on= date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

DataMapper.finalize

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

helpers SongHelpers