require 'sinatra'

get '/' do
  erb :form
end

post "/submit" do
  params
end
