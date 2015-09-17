require 'sinatra'
require 'uri'
require 'net/http'
require 'json'

get '/' do
  erb :form
end

post "/submit" do
  name = "#{params['lastname']}, #{params['title']} #{params['firstname']}"
  params["name"] = name
  params.delete("firstname")
  params.delete("lastname")
  params.delete("title")

  params["sibsp"] = params["sibsp"].to_i
  params["parch"] = params["parch"].to_i
  params["age"] = params["age"].to_i

  params["sibsp"] = params["sibsp"] + 1 if params["spouse"] == "yes"
  params.delete("spouse")

  params["fare"] = 60
  params["cabin"] = "B5"
  params["home.dest"] = "Chicago, IL"
  params["ticket"] = 42

  uri = URI.parse("http://syberia-titanic-demo.elasticbeanstalk.com/score")
  req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
  req.body = params.to_json
  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
  end
  score = JSON.parse(res.body)["score"].to_f
  score_formula = 1/(1 + (2.71828 ** -score)) * 2 - 1
  "<b><font size='+3'>Chance of survival: #{(score_formula * 100).to_s[0..5]}%</font></b>" 
end
