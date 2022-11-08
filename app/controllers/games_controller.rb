require 'open-uri'
require 'json'
require 'time'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    grid_size = 20
    @grid_arr = []
    # TODO: generate random grid of letters
    grid_size.times { @grid_arr << ('a'..'z').to_a.sample(1)[0] }
    session[:grid_arr] = @grid_arr
    session[:start_time] = @start_time
  end

  def score
    grid_arr = session[:grid_arr]
    start_time = session[:start_time]
    end_time = Time.now
    time = end_time - start_time.to_datetime
    word = params[:word]
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    # @time = @end_time - @start_time
    isvalid = false
    word.chars.each do |element|
      found_arr = grid_arr.find_index(element.downcase)
      puts grid_arr
      if found_arr.nil?
        isvalid = false
        return @score_out = { score: 0, message: "not in the grid", time: time }
      else
        isvalid = true
        grid_arr.delete_at(found_arr)
      end
    end
    char_length = word.chars.length
    score = char_length.to_f / time
    if isvalid
      url = "https://wagon-dictionary.herokuapp.com/#{word}"
      read_info = URI.open(url).read # Fetch data from URI
      read_json = JSON.parse(read_info)
      if read_json["found"] == true
        return @score_out = { score: score, message: "well done", time: time }
      else
        return @score_out = { score: 0, message: "not an english word", time: time }
      end
    end

    return @score_out = { score: 0, message: "not in the grid", time: time }

  end
end
