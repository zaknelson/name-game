require 'sinatra/base'
require 'elo'

class MyServer < Sinatra::Base

  def self.run!
    @player = Elo::Player.new(:rating => 1500)
    super
  end

  get '/' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  get '/test' do
    @player.rating
  end
end