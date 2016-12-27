require 'sinatra'
require 'elo'

  
player = Elo::Player.new(:rating => 1500)

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/test' do
  "hello"
end

get '/test2' do
  player.rating
end