# TODO:Primitive queries such us RangeFriends
require 'mongo'
include Mongo

class GeoPrimitiveQueries
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

class SocialPrimitiveQueries
	attr_accessor :people
        # Create the object
	def initialize()
	    
	end
 	def getFriends(userid)
		people.find("userId" => userid).to_a
	end
 	def areFriends(userid_1, userid_2)
		people.find("userId" => user_id1, "friend_ids" => {"$in" => userid_2}).to_a
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
		"friend_ids" => [1,2,3,4,5,6,7,8,9,10],
		"loc" => [i+10, i+20]
	}
	id = people.insert(doc)
}

#pq = GeoPrimitiveQueries.new
#pq.people = people

#pq.x = 10
#pq.y = 10
#pq.findNearest
socialPrimitives = SocialPrimitiveQueries.new
socialPrimitives.people = people
friends = socialPrimitives.getFriends(1)
puts friends

