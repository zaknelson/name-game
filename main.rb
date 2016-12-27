require 'sinatra'
require 'elo'
require 'json'

  
players = Hash.new

File.open(File.join(settings.public_folder, 'names.csv'), "r") do |f|
  f.each_line do |line|
    values = line.split(",")
    players[values[0]] = {:name => values[0], :elo_player => Elo::Player.new(:rating => values[1].to_i) };
  end
end 

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/names' do
  content_type :json 
  sorted_players = players.values;
  result = []
  sorted_players.sort! do |x, y| 
    if x[:elo_player].rating == y[:elo_player].rating
      x[:name] <=> y[:name]
    else
     y[:elo_player].rating <=> x[:elo_player].rating  
    end
  end
  sorted_players.each do |player|
    result.push({:name => player[:name], :rating => player[:elo_player].rating})
  end
  result.to_json
end

get '/names/random' do
  rand = Random.new
  first = rand.rand(players.size)
  second = first
  while (second == first) do
    second = rand.rand(players.size)
  end
  result = []
  result.push(players.keys[first])
  result.push(players.keys[second])
  result.to_json
end

post '/games' do
  values = JSON.parse(request.env['rack.input'].read)
  players[values['winner']][:elo_player].wins_from(players[values['loser']][:elo_player])
  200
end

get '/' do
  player.rating.to_s
end