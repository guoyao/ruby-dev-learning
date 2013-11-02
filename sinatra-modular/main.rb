require 'slim'
require 'pony'
require './app/controllers/application_controller'

class Website < ApplicationController
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

  get '/' do
    @title = 'index'
    slim :index
  end

  get '/about' do
    slim :about
  end

  get '/contact' do
    slim :contact
  end

  post '/contact' do
    send_message
    flash[:notice] = "Thank you for your message. We'll be in touch soon."
    redirect to('/')
  end

end
