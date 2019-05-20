require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def valid?(guess, letters)
    guess.chars.all? { |l| guess.count(l) <= letters.count(l) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def score
    # binding.pry
    @guess = params[:input]
    @letters = params[:letters]
    result_array = score_and_message(@guess, @letters)
    @score = result_array[0]
    @message = result_array[1]
  end

  def score_and_message(input, letters)
    if valid?(input.upcase, letters)
      if english_word?(input)
        score = input.length * 10
        [score, 'Blessed!']
      else
        [0, 'Not English, sorry.']
      end
    else
      [0, 'Cheers, get some glasses.']
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
