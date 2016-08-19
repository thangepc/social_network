require 'rails_helper'
require 'faker'

RSpec.describe User, :type => :model do
	email = 'nguyenthang@gmail.com'
	password = 'thangEPC1234@'
	first_name = Faker::Name.first_name
	last_name = Faker::Name.last_name
	# puts email
    users = User.create( email: email, password: password, first_name: first_name, last_name: last_name)
	context "db" do
		context "columns" do
			it { should have_db_column(:first_name).of_type(:string).with_options(null: true) }
			it { should have_db_column(:last_name).of_type(:string).with_options(null: true) }
			it { should have_db_column(:email).of_type(:string).with_options(null: true) }
			it { should have_db_column(:address).of_type(:string).with_options(null: true) }
			it { should have_db_column(:phone).of_type(:string).with_options(null: true) }
			it { should have_db_column(:points).of_type(:float).with_options(default: 0.0) }
			it { should have_db_column(:created_at).of_type(:datetime) }
			it { should have_db_column(:updated_at).of_type(:datetime) }
		end
	end

	context "attributes" do

	    it "has email" do
	    	email = Faker::Internet.email
	    	# puts email
	      	expect(build(:user, email: email)).to have_attributes(email: email)
	    end

	    it "has first_name" do
	    	first_name = Faker::Name.first_name
	      	expect(build(:user, first_name: first_name)).to have_attributes(first_name: first_name)
	    end

	    it "has last_name" do
	    	last_name = Faker::Name.last_name
	      	expect(build(:user, last_name: last_name)).to have_attributes(last_name: last_name)
	    end

	    it "has address" do
	    	address = Faker::Address.street_address
	      	expect(build(:user, address: address)).to have_attributes(address: address)
	    end

	    it "has phone" do
	    	phone = Faker::PhoneNumber.phone_number
	      	expect(build(:user, phone: phone)).to have_attributes(phone: phone)
	    end

	    it "has points" do
	    	point = Faker::Number.decimal(2)
	      	expect(build(:user, points: point.to_f)).to have_attributes(points: point.to_f)
	    end

	    it "has created_at" do
	    	created_at = Date.today
	      	expect(build(:user, created_at: created_at)).to have_attributes(created_at: created_at)
	    end
	    
	    it "has updated_at" do
	    	updated_at = Date.today
	      	expect(build(:user, updated_at: updated_at)).to have_attributes(updated_at: updated_at)
	    end
	  end

	context "validation" do
		email = Faker::Internet.email
		password = Faker::Internet.password
		first_name = Faker::Name.first_name
		last_name = Faker::Name.last_name
		# puts email
	    let(:user) { build(:user, email: email, password: password, first_name: first_name, last_name: last_name) }

	    it "requires unique email" do
	      expect(user).to validate_uniqueness_of(:email)
	    end

	    it "requires email" do
	      expect(user).to validate_presence_of(:email)
	    end

	    it "requires first_name" do
	      expect(user).to validate_length_of(:first_name)
	    end

	    it "requires last_name" do
	      expect(user).to validate_length_of(:last_name)
	    end
	  end

	context "authenticate function" do

	    # it 'email or password wrong' do
	    # 	check = User.authenticate('abc@gmail.com', '123123')
	    # 	expect(check).to eq(nil)
	    # end

	    it 'email and password correct' do
	    	# check = User.authenticate('nguyenthang@gmail.com', 'thangEPC123@')
	    	# puts 'CHECK: '
	    	# puts check
	    	# expect(check).to eq(nil)
	    end
	end	  
end