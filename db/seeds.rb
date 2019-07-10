# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
20.times do
  Book.create(
    title: Faker::Book.title,
    genre: Faker::Book.genre,
    author: Faker::Book.author,
    publisher: Faker::Book.publisher,
    description: Faker::Lorem.paragraph_by_chars,
    remote_cover_url: "https://softcover.s3.amazonaws.com/636/ruby_on_rails_tutorial_solutions_manual/images/cover-web.png",
    price: Faker::Number.number(6).to_f
  )
end