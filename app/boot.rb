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
  "A male is #{Gender::MALE}"
end
