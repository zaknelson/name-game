require 'sinatra'
require 'elo_rating'
require 'json'
  
set :protection, :except => [:json_csrf]


players = Hash.new
$rand = Random.new
$current_round = []
$next_round = []

File.open(File.join(settings.public_folder, 'names.csv'), "r") do |f|
  f.each_line do |line|
    values = line.split(",")
    players[values[0]] = {:name => values[0], :rating => values[1].to_i };
    $current_round.push(players[values[0]])
  end
end

def get_random_player
  i = $rand.rand($current_round.size)
  player = $current_round[i]
  $next_round.push(player)
  $current_round.delete_at(i)
  if ($current_round.size == 0)
    $next_round.each do |p|
      if (p[:rating] > 1450)
        $current_round.push(p)
      end
    end
    $next_round = []
  end
  player
end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/names' do
  content_type :json 
  sorted_players = players.values;
  result = []
  sorted_players.sort! do |x, y| 
    if x[:rating] == y[:rating]
      x[:name] <=> y[:name]
    else
     y[:rating] <=> x[:rating]  
    end
  end
  sorted_players.to_json
end

get '/names/random' do
  first = get_random_player()
  second = get_random_player()
  result = []
  result.push(first[:name])
  result.push(second[:name])
  result.to_json
end

post '/games' do
  values = JSON.parse(request.env['rack.input'].read)
  winners = values['winners']
  losers = values['losers']

  # Get current ratings
  match = EloRating::Match.new
  if (winners.size == 0)
    match.add_player(rating: 1000, winner: true)
  else
    winners.each do |winner|
      match.add_player(rating: players[winner][:rating], winner: true)
    end
  end
  losers.each do |loser|
    match.add_player(rating: players[loser][:rating])
  end

  # Update ratings
  new_ratings = match.updated_ratings
  if (winners.size == 0)
    new_ratings.shift
  end
  winners.each do |winner|
    players[winner][:rating] = new_ratings.shift
  end
  losers.each do |loser|
    players[loser][:rating] = new_ratings.shift
  end

  200
end

get '/' do
  player.rating.to_s
end