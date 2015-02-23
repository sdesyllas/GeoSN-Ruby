#Primitive queries
require 'mongo'
require_relative 'geoModule'
require_relative 'socialModule'
include Mongo

#Query point of coordinates, longitude and latitude
class QueryPoint
	attr_accessor :long
	attr_accessor :lat
	def initialize(long, lat)
		@long = long
		@lat = lat
	end
end



class PrimitiveTester
	def self.test()
		mongo_client = MongoClient.new("localhost", 27017)

		db = mongo_client.db("geoSNDB")
		people = db.collection("userCollection")

		#testing social primitives
		social = SocialPrimitiveQueries.new
		social.people = people
		friends_of_1 = social.getFriends(1)
		areFriends = social.areFriends(1, 2)
		puts "============================================"
		puts "friends_of_1 : #{friends_of_1.inspect}"
		puts "============================================"
		puts "areFriends : #{areFriends.inspect}"

		#testing social primitives
		geo = GeoPrimitiveQueries.new
		geo.people = people
		rangeUsers = geo.rangeUsers(QueryPoint.new(37.983917, 23.729360), 100) #Athens coordinates
		nearestUsers = geo.findNearest(QueryPoint.new(37.983917, 23.729360), 3) #Athens coordinates
		userLocation = geo.getUserLocation(1)	
		puts "============================================"
		puts "GetUserLocation : #{userLocation}"
		puts "============================================"
		puts "rangeUsers : #{rangeUsers}"
		puts "============================================"
		puts "nearestUsers : #{nearestUsers}"
		puts "============================================"
	end
end

#PrimitiveTester.test


