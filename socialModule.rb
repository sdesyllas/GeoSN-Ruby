#Primitive queries
require 'mongo'
include Mongo

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
