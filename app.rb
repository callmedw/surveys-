require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"
require './lib/survey'
require './lib/question'
require 'pry'

also_reload('lib/**/*.rb')

get('/') do
  @surveys = Survey.all
  @question = Question.all
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
  @question = Question.all
  erb :survey
end

patch '/surveys/:id' do
  @survey = Survey.find(params.fetch('id').to_i)
  title = params.fetch('title')
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

get '/questions/:id' do
  @question = Question.find(params.fetch('id').to_i)
  erb :question
end

patch '/questions/:id' do
  question = params.fetch('question')
  @question = Question.find(params.fetch('id').to_i)
  @question.update({:description => question})
  redirect "/"
end

delete '/questions/:id' do
  @question = Question.find(params.fetch('id').to_i)
  @question.delete
  @questions = Question.all
  redirect '/'
end
