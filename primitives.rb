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

# Primitive Queries, Social Module
#GetFriends(u): given a user u , return u's friends
#AreFriends(ui, uj): Given two users, user_i, user+j, return true if user_i,user_j are friends,
#and false otherwise
class SocialPrimitiveQueries
	attr_accessor :people
        # Create the object
	def initialize()
	    
	end
 	def getFriends(userid) 
		people.find("friend_ids" => {"$in" => [userid]}).to_a
	end
 	def areFriends(userid_1, userid_2)
		people.find("userId" => userid_1, "friend_ids" => {"$in" => [userid_2]}).count > 0
	end
end

mongo_client = MongoClient.new("localhost", 27017)

db = mongo_client.db("geoSNDB")
people = db.collection("userCollection")

#testing social primitives
social = SocialPrimitiveQueries.new
social.people = people
friends_of_1 = social.getFriends(1)
areFriends = social.areFriends(1, 2)

puts "friends_of_1 : #{friends_of_1.inspect}"
puts "areFriends : #{areFriends.inspect}"

