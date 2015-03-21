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

	#algorithm variation 1
	def rangeFriends_1(userId, q, r)
		result = Array.new
		friends = socialModule.getFriends(userId)
		friends.each { |friend|
			userLocation = geoModule.getUserLocation(friend['userId'])
			rangeUsers = geoModule.rangeUsers(QueryPoint.new(userLocation[0], userLocation[1]), r)
			results = []
			rangeUsers.each { |rangeUser|
				if rangeUser["userId"] == friend['userId']
				  result.push(rangeUser)
				end
			}
		}
		result
	end

	#algorithm variation 2
	def rangeFriends_2(userId, q, r)
		result = Array.new
		rangeUsers = geoModule.rangeUsers(q, r)
		friends = socialModule.getFriends(userId)
		friends.each { |friend|
				if rangeUsers.select{ |item| item['userId'] == friend['userId'] }.count>0
					result.push(friend)
				end
		}
		result
	end

	#algorithm variation 3
	def rangeFriends_3(userId, q, r)
		result = Array.new
		rangeUsers = geoModule.rangeUsers(q, r)
		rangeUsers.each { |user|
			if socialModule.areFriends(userId, user['userId']) == true
				result.push(user)
			end
		}
		result
	end


	#input : User u, positive integer k
	#output : Result set R
	def nearestFriends(u, r)
		resultSet = Array.new
		friends = socialModule.getFriends(u)
		friends.each { |friend|
			userLocation = geoModule.getUserLocation(friend['userId'])
			resultSet.push([friend['userId'], userLocation])
		}
		resultSet
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

timer1 = Time.now.to_f
rangeFriends = geoSN.rangeFriends_1(1, QueryPoint.new(37.983917, 23.729360), 100)
puts "==========================="
puts "RangeFriends Variation 1 of user 1 from Athens: #{rangeFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"

timer1 = Time.now.to_f
rangeFriends = geoSN.rangeFriends_2(1, QueryPoint.new(37.983917, 23.729360), 100)
puts "==========================="
puts "RangeFriends Variation 2 of user 1 from Athens: #{rangeFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"

timer1 = Time.now.to_f
rangeFriends = geoSN.rangeFriends_3(1, QueryPoint.new(37.983917, 23.729360), 100)
puts "==========================="
puts "RangeFriends Variation 3 of user 1 from Athens: #{rangeFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"



timer1 = Time.now.to_f
nearestFriends = geoSN.nearestFriends(1, 10)
puts "==========================="
puts "NearestFriends of user 1: #{nearestFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"
