require 'mongo'
include Mongo

mongo_client = MongoClient.new("localhost", 27017)

db = mongo_client.db("geoSNDB")
people = db.collection("userCollection")
people.drop

people.create_index("userId")
people.create_index(:loc => Mongo::GEO2D)
# create 100 random users
100.times { |i| 
	doc = {
		"userId" => i, 
		"userName" => "TestUser", 
		"count" => 1, 
		"friend_ids" => [i-2, i-1, i+1, i+2],
		"loc" => [Random.rand(180), Random.rand(180)] #Random Coordinates
	}
	id = people.insert(doc)
	puts "Inserted : #{doc}"
}
total = people.count
puts "Inserted #{total} users and scattered at random coordinates"

