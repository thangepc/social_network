class User < ActiveRecord::Base
	has_secure_password

	has_many :friends

	# Validation	
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_presence_of :password, :on => :create
	validates_length_of :password ,{:minimum => 2, :maximum => 255, :on => :create}
	validates_length_of :first_name ,{:minimum => 2, :maximum => 255}
	validates_length_of :last_name ,{:minimum => 2, :maximum => 255}

	# Pagination
	self.per_page = 15

	def self.authenticate(email, password)
		user = self.find_by_email(email)
		# render :json => user
		# return
	    if user && user.password_digest == BCrypt::Engine.hash_secret(password, user.password_digest)
	      user
	    else
	      nil
	    end
	end

	def self.search(query)
		@users = User.where('first_name LIKE ? OR last_name LIKE ? OR address LIKE ? OR phone LIKE ? OR email LIKE ?', "%" +query + "%", "%" +query + "%", "%" +query + "%", "%" +query + "%", "%" +query + "%").all
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
end
