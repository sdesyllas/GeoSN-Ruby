#Primitive queries
require 'mongo'
include Mongo
require_relative 'helpers'

#Primitive Queries GeoLocation Module
#RangeUsers(q,r): Given a query point q and distance in meters r, return the users within distance r
#from q, along with their locations.
#NearestUsers(q,k): Given a query point q and an integer k, return the k users nearest to q in
#in ascending distance, along with their locations
class GeoPrimitiveQueries
	attr_accessor :people

 	def nearestUsers(q, k)
		resultSet = Array.new
		nearestUsers = people.find({"loc" => {"$near" => [q.long, q.lat]}}, {:limit => k}).to_a
		nearestUsers.each do |person|
			distance = distance([q.long, q.lat] ,[person['loc'][0], person['loc'][1]])
			resultSet.push([person['userId'], person['userName'], distance])
		end
		#sort by distance ascending
		resultSet.sort_by{ |hash| hash[2].to_i }
	end
 	def getUserLocation(u)
		people.find_one({"userId" => u})['loc']
	end
	def rangeUsers(q, r)
		people.find({"loc" => {"$near" => [q.long, q.lat], "$maxDistance"=>r}}, {:limit => 10000}).to_a
	end
end
