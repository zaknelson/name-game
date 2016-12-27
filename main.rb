require 'sinatra'
require 'elo'

  
players = Hash.new

File.open("my/file/path", "r") do |f|
  f.each_line do |line|
    values = line.split(",")
    players[values[0]] = {:name => values[0], :elo_player => Elo::Player.new(:rating => values[1]) };
  end
end 

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/names' do
  content_type :json 
  sorted_players = players.values;
  sorted_players.sort! do |x, y| 
    if x[:elo_player].rating == y[:elo_player].rating
      x[:elo_player].rating <=> y[:elo_player].rating 
    else
      x[:name] <=> y[:name]
    end
  end
  sorted_players.to_json
end

get '/' do
  player.rating.to_s
end