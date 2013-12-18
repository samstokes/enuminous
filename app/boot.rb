require 'sinatra'
require 'enuminous'

class Gender < Enum
  value :male
  value :female

  def_case :address do
  when_male { 'Sir' }
  when_female { "Ma'am" }
  end
end

get '/' do
  %w(male female other).map do |gender|
    begin
      "A #{gender} is #{Gender.const_get(gender.upcase.to_sym)}"
    rescue NameError => e
      "A #{gender} is regrettably not recognised"
    end
  end.map do |thing|
    "<p>#{thing}</p>"
  end
end
