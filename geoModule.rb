#Primitive queries
require 'mongo'
include Mongo

#Primitive Queries GeoLocation Module
#RangeUsers(q,r): Given a query point q and distance in meters r, return the users within distance r
#from q, along with their locations.
#NearestUsers(q,k): Given a query point q and an integer k, return the k users nearest to q in
#in ascending distance, along with their locations
class GeoPrimitiveQueries
	attr_accessor :people

	def rangeUsers(q, r)
		people.find({"loc" => {"$near" => [q.long, q.lat], "$maxDistance"=>r}}, {:limit => 100}).to_a
	end
 	def findNearest(q, k)
		people.find({"loc" => {"$near" => [q.long, q.lat]}}, {:limit => k}).to_a
	end
 	def getUserLocation(u)
		people.find_one({"userId" => u})['loc']
	end
end
