#This class corresponds to a table in the database
class Link

	include DataMapper::Resource

	has n, :tags, :through => Resource
	
	#this block will have the resources our models will have
	property :id, Serial #Serial means it will auto-increment for each record
	property :title, String
	property :url, String

end