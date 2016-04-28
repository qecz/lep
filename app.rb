#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db=SQLite3::Database.new  'lep.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do

init_db

@db.execute 'CREATE TABLE if not exists Posts 
(
	id PRIMARY KEY, 
	Content TEXT, 
	create_date DATETIME
)'

@db.execute 'CREATE TABLE if not exists Comments 
(
	id INTEGER PRIMARY KEY AUTOINCREMENT, 
	content TEXT, 
	create_date DATETIME
	post_id integer
)'

end


get '/' do

	@result = @db.execute 'select * from Posts order by id desc'
	erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  
content = params[:content]

if content.length < 1
	@error = "Введите текст"
	return erb :new
end

@db.execute 'insert into Posts (content, create_date) values (?, datetime())', [content]

#erb "You typped #{content}" 

redirect to '/'

end

get '/details/:post_id' do

	post_id = params[:post_id]

result = @db.execute 'select * from Posts where id = ?', [post_id]
@row = result[0]
	#erb "Displaying info #{post_id}"
erb :details
end

#обработчик пост запроса детеилс
post '/details/:post_id' do

	post_id = params[:post_id]
	content = params[:content]

	erb "You typped #{content} for #{post_id}"
	
end
