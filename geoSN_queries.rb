#GeoSN Queries
require 'mongo'
include Mongo
# 'primitives.rb'
require_relative 'geoModule'
require_relative 'socialModule'
require_relative 'helpers'

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
		queryPoint = [q.lat, q.long]
		friends = socialModule.getFriends(userId)
		friends.each do |friend|
			userLocation = geoModule.getUserLocation(friend['userId'])
			friendDistance = distance(queryPoint, userLocation)
			puts "distance #{friendDistance}"
			if friendDistance <= r
				result.push(friend)
			end
		end
		result
	end

	#algorithm variation 2
	def rangeFriends_2(userId, q, r)
		result = Array.new
		rangeUsers = geoModule.rangeUsers(q, r)
		friends = socialModule.getFriends(userId)
		friends.each do |friend|
				if rangeUsers.select{ |item| item['userId'] == friend['userId'] }.count>0
					result.push(friend)
				end
		end
		result
	end

	#algorithm variation 3
	def rangeFriends_3(userId, q, r)
		result = Array.new
		rangeUsers = geoModule.rangeUsers(q, r)
		rangeUsers.each do |user|
			if socialModule.areFriends(userId, user['userId']) == true
				result.push(user)
			end
		end
		result
	end


	#input : User u, location q, positive integer k
	#output : Result set R
	def nearestFriends_1(u, q)
		resultSet = Array.new
		friends = socialModule.getFriends(u)
		friends.each do |friend|
			userLocation = geoModule.getUserLocation(friend['userId'])
			friendDistance = distance([q.lat, q.long], userLocation)
			resultSet.push([friend['userId'], friend['userName'], friendDistance])
		end
		resultSet.sort_by{ |hash| hash[2].to_i }
	end

	#input : User u, positive integer k
	#output : Result set R
	def nearestFriends_2(u, q, k)
		resultSet = Array.new
		friends = socialModule.getFriends(u)
		nearestUsers = geoModule.nearestUsers(q, k)
		nearestUsers.each do |nearestUser|
			friends.each do |friend|
				if friend['userId'] == nearestUser[0]
					resultSet.push([friend['userId'], friend['userName'], nearestUser[2]])
				end
			end

		end
		resultSet
	end

	#input : User u, positive integer k
	#output : Result set R
	def nearestFriends_3(u, q, k)
		resultSet = Array.new
		nearestUsers = geoModule.nearestUsers(q, k)
		nearestUsers.each do |nearestUser|
			if socialModule.areFriends(u, nearestUser[0])
				resultSet.push([nearestUser[0], nearestUser[1], nearestUser[2]])
			end
		end
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
k = 10000
puts "==========================="
timer1 = Time.now.to_f
rangeFriends = geoSN.rangeFriends_1(1, QueryPoint.new(37.983917, 23.729360), k)
puts ""
puts "RangeFriends Variation 1 of user 1 from Athens: #{rangeFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"

timer1 = Time.now.to_f
rangeFriends = geoSN.rangeFriends_2(1, QueryPoint.new(37.983917, 23.729360), k)
puts ""
puts "RangeFriends Variation 2 of user 1 from Athens: #{rangeFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"

timer1 = Time.now.to_f
rangeFriends = geoSN.rangeFriends_3(1, QueryPoint.new(37.983917, 23.729360), k)
puts ""
puts "RangeFriends Variation 3 of user 1 from Athens: #{rangeFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"

puts ""
puts "==========================="
puts ""
timer1 = Time.now.to_f
nearestFriends = geoSN.nearestFriends_1(1, QueryPoint.new(37.983917, 23.729360))
puts "NearestFriends Variation 1 of user 1: #{nearestFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"

puts ""
timer1 = Time.now.to_f
nearestFriends = geoSN.nearestFriends_2(1, QueryPoint.new(37.983917, 23.729360), k)
puts "NearestFriends Variation 2 of user 1: #{nearestFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"

puts ""
timer1 = Time.now.to_f
nearestFriends = geoSN.nearestFriends_3(1, QueryPoint.new(37.983917, 23.729360), k)
puts "NearestFriends Variation 3 of user 1: #{nearestFriends}"
timer2 = Time.now.to_f
diff = (timer2-timer1)*1000
puts "Finished at : #{diff} ms"
