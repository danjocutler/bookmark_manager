get '/' do
	@links = Link.all
	erb :index
end

post '/' do
	
end