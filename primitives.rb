# TODO:Primitive queries such us RangeFriends
require 'mongo'
include Mongo

class PrimitiveQueries
	attr_accessor :x
	attr_accessor :y
	attr_accessor :people
        # Create the object
	def initialize(distance = "10")
	    @distance = distance
	end
	
 	def findNearest
		people.find({"loc" => {"$near" => [x, y]}}, {:limit => 5}).each do |p|
		  puts p.inspect
		end
	end
end	

mongo_client = MongoClient.new("localhost", 27017)

db = mongo_client.db("geoSNDB")
people = db.collection("userCollection")
#people.drop

people.create_index("userId")
people.create_index(:loc => Mongo::GEO2D)
# create 100 random users
100.times { |i| 
	doc = {
		"userId" => i, 
		"userName" => "TestUser", 
		"count" => 1, 
		"loc" => [i+10, i+20]
	}
	id = people.insert(doc)
}

pq = PrimitiveQueries.new
pq.people = people

pq.x = 10
pq.y = 10
pq.findNearest
	


