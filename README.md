# GeoSN-Ruby
A Geo Social Network experimental work using MongoDB geo-spatial indexes and client for queries build with Ruby.

The program is separated in two modules, the geo module and the social module. The general framework is making use of primitive mechanics of geo and social module in order to achieve more complex queries like RangeFriends and NearestFriends.
The documents for both modules are stored in MongoDB. For the geo module GEO2D spatial index has been used

The implementation is based on and inspired by the following Academic Paper:
* A general framework for geo-social query processing (http://dl.acm.org/citation.cfm?id=2536218)
