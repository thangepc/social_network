# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

# # User
csv_user_text = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
csv_user = CSV.parse(csv_user_text, :headers => true, :encoding => 'ISO-8859-1')
csv_user.each do |row|
  t = User.new
  # t.save
  t.first_name = row['first_name']
  t.last_name = row['last_name']
  t.email = row['email']
  t.password = row['password']
  t.address = row['address']
  t.phone = row['phone']
  t.save
puts 'SAVED'
end

