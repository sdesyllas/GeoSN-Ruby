#GeoSN Queries
require 'mongo'
include Mongo
# 'primitives.rb'
require_relative 'geoModule'
require_relative 'socialModule'
require_relative 'primitives'

mongo_client = MongoClient.new("localhost", 27017)

db = mongo_client.db("geoSNDB")
people = db.collection("userCollection")
people = db.collection("userCollection")

puts "Ready to perform queries in MongoDB, database currently has #{people.count} people"

class GeoSN
	attr_accessor :socialModule
	attr_accessor :geoModule
	
	# Giver a user u , a 2D point q and a distance in meters r
	# returns users withing the distance that they are friends together
	def rangeFriends(userId, q, r)
		result = Array.new
		rangeUsers = geoModule.rangeUsers(q, r)
		rangeUsers.each { |user|
			if socialModule.areFriends(userId, user['userId']) == true
				result.push(user)
			end
		}
		result
	end 
end

#init social module
social = SocialPrimitiveQueries.new
social.people = people
#init geo module
geo = GeoPrimitiveQueries.new
geo.people = people

geoSN = GeoSN.new
geoSN.geoModule = geo
geoSN.socialModule = social

rangeFriends = geoSN.rangeFriends(1, QueryPoint.new(37.983917, 23.729360), 100)
puts "==========================="
puts "RangeFriends : #{rangeFriends}"