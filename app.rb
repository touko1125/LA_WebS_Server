require 'logger'
require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require './api'
require './utils/account.rb'
require './utils/hair.rb'
require 'dotenv/load'
require 'httparty'

set :port, ENV['PORT'] || 4567
set :bind, '0.0.0.0'

Dotenv.load

Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUD_NAME']
    config.api_key    = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
end

configure do
    enable :sessions

    use Rack::Session::Cookie,
        :path => '/',
        :expire_after => 86400,
        :secret => ENV['SESSION_SECRET']
end

helpers do
    def logged_in?
        if session[:user_id]
            return true
        else
            return false
        end
    end

    def partial(template, locals = {})
        erb :"partial/#{template}", { layout: false }, locals
    end
end

before do
  @isAuthed = logged_in?
  @user = User.find_by(id: session[:user_id])
end

get '/' do
    erb :index
end

get '/home' do
    @trend_hair_histories = convert_hair_histories_to_models(get_trend_hair_history_ids())
    @new_hair_histories = convert_hair_histories_to_models(get_new_hair_history_ids())
    if @isAuthed
        @friend_hair_histories = convert_hair_histories_to_models(get_friend_hair_history_ids(@user))
    end
    erb :index
end

get '/hair_history/:id' do
    @detail = HairHistory.find(params[:id])
    erb :detail
end

get '/profile' do
    if @isAuthed
        @user_hair_histories = convert_hair_histories_to_models(get_user_hair_history_ids(@user))
        erb :user
    else
        redirect '/signin'
    end
end

get '/search' do
    erb :search
end

get '/signin' do
    erb :signin
end

get '/signup' do
    erb :signup
end

get '/signout' do
    session[:user_id] = nil
    redirect '/home'
end

post '/user/:user_id/hair_history/:history_id/like' do
    like_hair_history(params[:user_id], params[:history_id])
    redirect '/home'
end

post '/user/:user_id/hair_history/:history_id/bookmark' do
    bookmark_hair_history(params[:user_id], params[:history_id])
    redirect '/home'
end

post '/signin' do
    user = signin(params[:email], params[:password])
    if user.nil?
        erb :signin
    else
        session[:user_id] = user.id
        redirect '/home'
    end
end

post '/signup' do
    user = signup(params[:name], params[:email], params[:password], params[:image_file])
    if user.nil?
        erb :signup
    else
        session[:user_id] = user.id
        redirect '/home'
    end
end