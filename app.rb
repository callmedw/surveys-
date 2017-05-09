require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"
require './lib/survey'
require './lib/question'
require 'pry'

also_reload('lib/**/*.rb')

get('/') do
  @surveys = Survey.all
  erb(:index)
end

post('/surveys') do
  topic = params.fetch('topic')
  @survey = Survey.create({:topic => topic, :id => nil})
  erb(:success)
end

post('/questions') do
  question_input = params.fetch('question')
  survey_id = params.fetch('survey_id').to_i
  @survey = Survey.find(survey_id)
  @question = Question.create({:description => question_input, :survey_id => survey_id})
  erb(:success)
end

get '/surveys/:id' do
  @survey = Survey.find(params.fetch('id').to_i)
  erb :survey
end

patch '/surveys/:id' do
  @survey = Survey.find(params.fetch('id').to_i)
  title = params.fetch('title')
  # @survey.update({:topic => title})
  if (title.split('').any?)
    @survey.update({:topic => title})
  else
    @survey.update({:topic => "#{@survey.topic}"})
  end
  erb :survey
end

delete '/surveys/:id' do
  @survey = Survey.find(params.fetch('id').to_i)
  @survey.delete
  @surveys = Survey.all
  erb :index
end
# post("/employees") do
#   name = params.fetch("name")
#   division_id = params.fetch('division_id').to_i
#   @division = Division.find(division_id)
#   @employee = Employee.create({:name => name, :division_id => division_id})
#   erb(:success)
# end



#
# get("/divisions/:id") do
#   @division = Division.find(params.fetch("id").to_i())
#   erb(:division)
# end
#
# get("/divisions/:id/edit") do
#   @division = Division.find(params.fetch("id").to_i())
#   erb(:division_edit)
# end
#
# patch("/divisions/:id") do
#   @title = params.fetch("title")
#   @division = Division.find(params.fetch("id").to_i())
#   @division.update({:title => title})
#   erb(:division)
# end
#
# delete("/divisions/:id") do
#   @division = Division.find(params.fetch("id").to_i())
#   @division.delete()
#   @divisions = Division.all()
#   erb(:index)
# end
#
# post("/employees") do
#   name = params.fetch("name")
#   division_id = params.fetch('division_id').to_i
#   @division = Division.find(division_id)
#   @employee = Employee.create({:name => name, :division_id => division_id})
#   erb(:success)
# end
#
#
# get('/employees/:id/edit') do
#   @employee = Employee.find(params.fetch("id").to_i())
#   erb(:employee_edit)
# end
