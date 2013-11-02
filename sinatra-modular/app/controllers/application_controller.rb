require 'sinatra/base'
require 'sinatra/flash'
require 'sass'
require 'dm-core'
#require 'v8' # v8 is unnecessary if you have Node.js installed on your system.
require 'coffee-script'
require './sinatra/auth'

class ApplicationController < Sinatra::Base
  enable :sessions
  enable :method_override
  register Sinatra::Auth
  register Sinatra::Flash

  set :views, 'views'

  configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/development.db")
  end

  before do
    set_title
  end

  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/css/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path = '/')
    (request.path == path || request.path == path + '/') ? "current" : nil
  end

  def set_title
    @title ||= "Songs By Sinatra"
  end

  get('/css/main.css') { scss :main }

  get('/js/application.js') { coffee :application }

  not_found do
    slim :not_found
  end
end