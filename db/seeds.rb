# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



require 'rest-client'
require 'json'

Anime.destroy_all
Favorite.destroy_all
User.destroy_all
Review.destroy_all




res = RestClient.get("https://kitsu.io/api/edge/anime")
res_body = res.body
animes = JSON.parse(res_body)

file = File.read("./db/userjson.json")
users = JSON.parse(file)

comment_attributes = RestClient.get("https://kitsu.io/api/edge/comments")
all_comment_attributes = comment_attributes.body
reviews = JSON.parse(all_comment_attributes)

# favs = RestClient.get("https://kitsu.io/api/edge/comments")
# favs_body = favs.body
# favorites = JSON.parse(favs_body)



users["data"].each do |user|
    User.create(
    name: user["attributes"]["name"],
    bio: user["attributes"]["about"],
    birthday: user["attributes"]["birthday"],
    post_count: user["attributes"]["postsCount"],
    life_spent_on_anime: user["attributes"]["lifeSpentOnAnime"],
  )
 
end

animes["data"].each do |anime|
  Anime.create(
    title: anime["attributes"]["titles"]["en_jp"], 
    start_date: anime["attributes"]["createdAt"], 
    end_date: anime["attributes"]["updatedAt"],
    average_rating: anime["attributes"]["averageRating"], 
    poster_image: anime["attributes"]["posterImage"]["medium"], 
    synopsis: anime["attributes"]["synopsis"]
  )

  reviews["data"].each do |comment|
    Review.create(
      user_id: User.all.sample.id,
      anime_id: Anime.all.sample.id,
      comment: comment["attributes"]["content"],
      comment_likes: comment["attributes"]["likesCount"]
    )
  end

  # favorites["data"].each do |fav|
    20.times do Favorite.create(
    user_id: User.all.sample.id,
    anime_id: Anime.all.sample.id,
    rating: rand(0..10)
    )
end
puts "seeded"

end 