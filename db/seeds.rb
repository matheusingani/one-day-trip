require "open-uri"

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts "start seeding"
Experience.destroy_all

Place.destroy_all


file1 = URI.open("https://media.cntraveler.com/photos/5baa6077c4c3254b31283ff7/2:1/w_2560%2Cc_limit/GettyImages-547363801.jpg")
lisbon = Place.create(title: "Play Ping Pong at Le Wagon", city: "Lisbon", address: "Lisbon", description: "test street", user_id: User.last.id)
lisbon.photo.attach(io: file1, filename: "lisbon.png", content_type: "image/jpg")
print lisbon
lisbon.save!

file2 = URI.open("https://dynamic-media-cdn.tripadvisor.com/media/photo-o/29/14/db/71/caption.jpg?w=1200&h=-1&s=1")
lisbon2 = Place.create(title: "Take tram no. 28", city: "Lisbon", address: "Lisbon", description: "test street", user_id: User.last.id)
lisbon2.photo.attach(io: file2, filename: "lisbon2.png", content_type: "image/jpg")
print lisbon2
lisbon2.save!

file3 = URI.open("https://live.staticflickr.com/65535/51895932656_493c3f6ccb_h.jpg")
london = Place.create(title: "Go to tate modern", city: "London", address: "Lisbon", description: "test street", user_id: User.last.id)
london.photo.attach(io: file3, filename: "london.png", content_type: "image/jpg")
print london
london.save!


puts "amazing seeds done"
