require 'sinatra'
require 'sass'
require 'slim'
require 'sinatra/flash'
require 'pony'
require 'sinatra/reloader' if development?
require './app/models/song'

configure do
  enable :sessions
  set :session_secret, 'custom session secret'
  set :username, 'guoyao'
  set :password, '123456'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/development.db")
  set :port, 3000
  #set(:image_folder) { "#{Dir.pwd}/images/#{rand(100)}" }
end

before do
  set_title
end

#get('/main.css') { scss :main }
get('**/main.css') { scss :main }

get '/' do
  halt(401, 'Not Authorized') unless session[:admin]
  @title = 'index'
  slim :index
end

get '/login' do
  slim :login
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/songs')
  else
    slim :login
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end

get '/about' do
  halt(401, 'Not Authorized') unless session[:admin]
  slim :about
end

get '/contact' do
  halt(401, 'Not Authorized') unless session[:admin]
  slim :contact
end

post '/contact' do
  send_message
  flash[:notice] = "Thank you for your message. We'll be in touch soon."
  redirect to('/')
end

get '/songs' do
  find_songs
  slim :songs
end

get '/songs/new' do
  halt(401, 'Not Authorized') unless session[:admin]
  @song = Song.new
  slim :new_song
end

get '/songs/:id' do
  @song = find_song
  slim :show_song
end

post '/songs' do
  halt(401, 'Not Authorized') unless session[:admin]
  flash[:notice] = "Song successfully added" if create_song
  redirect to("/songs/#{@song.id}")
end

get '/songs/:id/edit' do
  halt(401, 'Not Authorized') unless session[:admin]
  @song = find_song
  slim :edit_song
end

put '/songs/:id' do
  halt(401, 'Not Authorized') unless session[:admin]
  song = find_song
  flash[:notice] = "Song successfully updated" if song.update(params[:song])
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  halt(401, 'Not Authorized') unless session[:admin]
  flash[:notice] = "Song successfully deleted" if find_song.destroy
  redirect to('/songs')
end

not_found do
  slim :not_found
end

helpers do
  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path = '/')
    (request.path == path || request.path == path + '/') ? "current" : nil
  end

  def set_title
    @title ||= "Songs By Sinatra"
  end

  def send_message
    Pony.mail(
        :from => params[:name] + "<" + params[:email] + ">",
        :to => 'account@gmail.com',
        :subject => params[:name] + " has contacted you",
        :body => params[:message],
        :port => '587',
        :via => :smtp,
        :via_options => {
            :address => 'smtp.gmail.com',
            :port => '587',
            :enable_starttls_auto => true,
            :user_name => '******',
            :password => '******',
            :authentication => :plain,
            :domain => 'localhost.localdomain'
    })
  end
end
