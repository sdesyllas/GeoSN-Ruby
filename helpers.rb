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

def distance loc1, loc2
  rad_per_deg = Math::PI/180  # PI / 180
  rkm = 6371                 # Earth radius in kilometers
  rm = rkm / 100             # Radius in meters

  dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
  dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  rm * c # Delta in meters

end


# => 57794.35510874037


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

		#testing geo primitives
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
