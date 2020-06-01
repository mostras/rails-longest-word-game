class GamesController < ApplicationController
  def new
    @start_time = Time.now
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alphabet[rand(alphabet.length)] }
  end

  def score
    end_time = Time.now
    @word = params[:word].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    api_response = open(url).read
    response = JSON.parse(api_response)
    response_found = response['found']
    response_length = response['length']

    checking_letters
    checking_english(response_found)

    compute_score(end_time, response_length) unless checking_letters && checking_english(response_found)
  end

  private

  def checking_letters
    @letters_array = params[:letters].split(' ').sort
    @word_array = params[:word].upcase.split(//).sort
    @error_letters = 'Sorry too many letters' if @word_array.length > 10
    check = []
    @word_array.each do |letter|
      check << @letters_array.include?(letter)
      @letters_array.delete(letter)
    end
    @error_letters = 'Sorry word incorrect' if check.include? false
  end

  def checking_english(response_found)
    @error_english = 'Sorry not an English word' unless response_found
  end

  def compute_score(end_time, response_length)
    start_time = params[:start_time].to_time
    @word_length = params[:length].to_i
    @total_time = end_time - start_time
    @score = response_length + (100 - @total_time).floor(2)
  end
end
