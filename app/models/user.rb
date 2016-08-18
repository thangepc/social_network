class User < ActiveRecord::Base
	has_secure_password

	has_many :friends

	# Validation	
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,3})\Z/i
	# validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
	validates_presence_of :password, :on => :create
	# validates_length_of :password ,{:minimum => 2, :maximum => 255, :on => :create}
	validates_strength_of :password, :with => :email, :level => :weak
	validates_length_of :first_name ,{:minimum => 2, :maximum => 255}
	validates_length_of :last_name ,{:minimum => 2, :maximum => 255}

	# Pagination
	self.per_page = 15

	def self.authenticate(email, password)
		user = self.find_by_email(email)
	    if user && user.password_digest == BCrypt::Engine.hash_secret(password, user.password_digest)
	      user
	    else
	      nil
	    end
	end

	def self.quick_search(query)
		@users = User.where('first_name LIKE ? OR last_name LIKE ? OR address LIKE ? OR phone LIKE ? OR email LIKE ?', "%" +query + "%", "%" +query + "%", "%" +query + "%", "%" +query + "%", "%" +query + "%").all
	end

	def self.search(params, user_id)
		keyQuery = ''
		valueQuery = nil
		case params[:type]
		when "name"
			if params[:keyword] != nil && params[:keyword] != ""
				keyQuery += "users.first_name LIKE :first_name OR users.last_name LIKE :last_name"
				valueQuery = {:first_name => "%" + params[:keyword] + "%", :last_name => "%" + params[:keyword] + "%"}
			end
		when "address"
			if params[:keyword] != nil
				keyQuery += "users.address LIKE :address"
				valueQuery = {:address => "%" + params[:keyword] + "%"}
			end
		when "phone"
			if params[:keyword] != nil
				keyQuery += "users.phone LIKE :phone"
				valueQuery = {:phone => "%" + params[:keyword] + "%"}
			end
		when "email"
			if params[:keyword] != nil
				keyQuery += "users.email LIKE :email"
				valueQuery = {:email => "%" + params[:keyword] + "%"}
			end
		else
			if params[:keyword] != nil && params[:keyword] != ""
				keyQuery += "users.first_name LIKE :first_name OR users.last_name LIKE :last_name"
				valueQuery = {:first_name => "%" + params[:keyword] + "%", :last_name => "%" + params[:keyword] + "%"}
			end
		end
		
		orderQuery = 'users.first_name ASC'
		if params[:sort] != nil && params[:order] != nil
			case params[:sort]
			when "name"
				orderQuery = "users.first_name " + params[:order]
			when "friends"
				orderQuery = "COUNT(friends.id) " + params[:order]
			when "favorites"
				orderQuery = "users.points " + params[:order]
			else
				orderQuery = "users.first_name " + params[:order]
			end
		end
		users = User.select("users.*").distinct.joins('LEFT JOIN friends on users.id = friends.user_id')
		if user_id != nil

			if keyQuery != "" && !valueQuery.empty?
				users = users.where('users.id <> ?', user_id).where(keyQuery, valueQuery).page(params[:page]).order(orderQuery)
			else
				users = users.where('users.id <> ?', user_id).page(params[:page]).order(orderQuery)
			end
		else
			if keyQuery != "" && !valueQuery.empty?
				users = users.where(keyQuery, valueQuery).page(params[:page]).order(orderQuery)
			else
				users = users.page(params[:page]).order(orderQuery)
			end
		end
	end

	# is_accept = 0 => request
	# 		  = 1 => accept
	# 		  = 2 => reject
	def get_invite_by_frient_id (user_id)
		friend = Friend.where("((user_id = ? AND user_friend_id =?) OR (user_id = ? AND user_friend_id = ?))", user_id, self.id, self.id, user_id).first
		if !friend.nil?
			friend.is_accept
		else
			0
		end
	end

	def fullname
		self.first_name + ' ' + self.last_name
	end

	def self.signup(params)
		user = User.new(params)
	    if user.save
	     	user
		else
			user
	    end
	end

	def self.signin(email, password)
		@user = User.authenticate(params[:session][:email], params[:session][:password])
	  	if 
	    	session[:user_id] = @user.id
	    	redirect_to root_path
	  	else
	  		flash[:message_error] = "Login fail"
	    	redirect_to signin_path()
	  	end 
	end

	# is_accept = 0 => requested
	# 		  = 1 => accept
	# 		  = 2 => reject
	def get_status_friend(user_id)
		if user_id != nil
			friend = self.friends.where('user_friend_id = ?', user_id).first
			if !friend.nil?
				friend.is_accept
			end
		else
			nil
		end
	end
	def get_favorite_friend(user_id)
		if user_id != nil
			friend = Friend.where('user_id = ? AND user_friend_id = ?', user_id, self.id).first
			if !friend.nil?
				friend.is_favorite
			end
		else
			nil
		end
	end

	def get_friends_number
		friends = self.friends.where('is_accept = ?', 1)
		friends.count
	end

end
