# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create(name: 'Luke', password: "password1")
User.create(name: 'Luke', password: "password1")
User.create(name: 'Luke', password: "password1")
User.create(name: 'Luke', password: "password1")
User.create(name: 'Luke', password: "password1")
User.create(name: 'Luke', password: "password1")

Topic.create(name: '#politics')
Topic.create(name: '#culture')

Link.create(name: 'Black Panther', url: "https://google.com")
Link.create(name: 'Iowa', url: "https://google.com")
