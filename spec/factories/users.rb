require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.first_name {Faker::Name.first_name}
    f.last_name {Faker::Name.last_name}
    f.email  {Faker::Internet.email}
    f.address  {Faker::Address.street_address}
    f.password  {Faker::Internet.password}
    f.phone  {Faker::PhoneNumber.phone_number}
    f.points  {Faker::Number.decimal(2)}
  end
end