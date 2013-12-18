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
  %w(male female).map do |gender|
    "A #{gender} is #{Gender.const_get(gender.upcase.to_sym)}"
  end.map do |thing|
    "<p>#{thing}</p>"
  end
end
