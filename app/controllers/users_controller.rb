class UsersController < ApplicationController
	before_action :require_user, only: [:index]


	def signup
		if request.request_method() == 'POST'
			@user = User.new(user_params)
		    if @user.save
		     	flash[:message_success] = "Register is successful."
		     	session[:user_id] = @user.id
				redirect_to root_path
			else
				flash[:message_error] = "Register isn't successful"
		    end
		else
			@user = User.new
		end
	end

	def signin
		if request.xhr?
			if request.request_method() == 'POST'
				@user = User.authenticate(params[:session][:email], params[:session][:password])
			  	if @user != nil
			    	session[:user_id] = @user.id
			    	# Add friend
			    	friend = Friend.where('(user_id = ? AND user_friend_id = ?) OR (user_id = ? AND user_friend_id = ?)', session[:user_id], params[:session][:id], params[:session][:id], session[:user_id]).first
					if friend.nil?
						friend = Friend.new(:user_id => session[:user_id], :user_friend_id => params[:session][:id], :is_accept => 0)
						friend.save
					end
					#End Add friend

			    	render :json => {status: 1, message: 'Successful'}
			  	else
			  		flash[:message_error] = "Login fail"
			    	render :json => {status: 0, message: 'Error'}
			  	end 
			end
		else
		  	if request.request_method() == 'POST'
				@user = User.authenticate(params[:session][:email], params[:session][:password])
			  	if @user != nil
			    	session[:user_id] = @user.id
			    	redirect_to root_path
			  	else
			  		flash[:message_error] = "Login fail"
			    	redirect_to signin_path()
			  	end 
			end
		end
	end

	def logout
		session[:user_id] = nil
		flash[:message_success] = "Logout is successful"
		redirect_to root_path()
	end

	def find_friend
		if params[:query]
			query = params[:query]
			@users = User.quick_search(query)
			response = []
			@users.each { |item|
				response << {'id' => item.id, 'name' => item.first_name, 'url' => 'abbccb'}
			}
			render :json	 => response
			# return
		end
	end

	def list_friends
		@users = User.search(params,session[:user_id])
		# render :json => @users
		# return
	end

	def add_friend
		if params[:id]
			user = User.find(params[:id])
			if !user.nil? && session[:user_id]
				friend = Friend.where('(user_id = ? AND user_friend_id = ?) OR (user_id = ? AND user_friend_id = ?)', session[:user_id], user.id, user.id, session[:user_id]).first
				if friend.nil?
					friend = Friend.new(:user_id => session[:user_id], :user_friend_id => user.id, :is_accept => 0)
					if friend.save
						friend2 = Friend.where('user_id = ? AND user_friend_id = ?', friend.user_friend_id, friend.user_id).first
						if friend2.nil?
							friend2 = Friend.new(:user_id => friend.user_friend_id, :user_friend_id => friend.user_id, :is_accept => -1)
							if friend2.save
								render :json => {status: 1, message: "Add friend is successful."}
							else
								render :json => {status: 0, message: "Error."}
							end
						else
							if friend2.update_column(:is_accept, params[:status])
								render :json => {status: 1, message: "Add friend is successful."}
							else
								render :json => {status: 0, message: "Error."}
							end
						end
						# render :json => {status: 1, message: "Add friend is successful."}
					end
				else
					render :json => {status: 0, message: "This member added to your friend ."}
				end
			else
				render :json => {status: 0, message: "Not found this friend."}
			end
		else
			render :json => {status: 0, message: "Not found this friend."}
		end
		return
	end

	def update_status_friend
		if request.request_method() == 'POST'
			if params[:id]
				friend = Friend.where('user_id = ? AND user_friend_id = ?', params[:id], session[:user_id]).first
				if !friend.nil?
					if friend.is_accept != 2
						if friend.update_column(:is_accept, params[:status])
							friend2 = Friend.where('user_id = ? AND user_friend_id = ?', friend.user_friend_id, friend.user_id).first
							if friend2.nil?
								friend2 = Friend.new(:user_id => friend.user_friend_id, :user_friend_id => friend.user_id, :is_accept => params[:status])
								if friend2.save
									render :json => {status: 1, message: "Successful."}
								else
									render :json => {status: 0, message: "Error."}
								end
							else
								if friend2.update_column(:is_accept, params[:status])
									render :json => {status: 1, message: "Successful."}
								else
									render :json => {status: 0, message: "Error."}
								end
							end
						else
							render :json => {status: 0, message: "Don't Successful."}
						end
					end
				end
			end
		end
	end

	# def remove_friend
	# 	if params[:id]
	# 		user = User.find(params[:id])
	# 		if !user.nil? && session[:user_id]
	# 			friend = Friend.where('(user_id = ? AND user_friend_id = ?) OR (user_id = ? AND user_friend_id = ?)', session[:user_id], user.id, user.id, session[:user_id]).first
	# 			if !friend.nil?
	# 				friend.destroy
	# 				render :json => {status: 1, message: "Remove friend is successful."}
	# 			end
	# 		else
	# 			render :json => {status: 0, message: "Not found this friend."}
	# 		end
	# 	else
	# 		render :json => {status: 0, message: "Not found this friend."}
	# 	end
	# 	return
	# end

	def add_friend_favorite
		if params[:id]
			user = User.find(params[:id])
			if !user.nil? && session[:user_id]
				friend = Friend.where('user_id = ? AND user_friend_id = ?', session[:user_id], user.id).first
				# render :json =>friend
				# return
				if !friend.nil?
					if friend.is_accept == 1
						if friend.update_column( :is_favorite, 1)
							me = User.find(session[:user_id])
							if !me.nil?
								me.points +=1
								me.save
							end
						end
						render :json => {status: 1, message: "Add to friend favorite is successful."}
					else
						render :json => {status: 0, message: "You don't add favorite for this friend."}
					end
				end
			else
				render :json => {status: 0, message: "Not found this friend."}
			end
		else
			render :json => {status: 0, message: "Not found this friend."}
		end
		return
	end

	def invite_friend
		render :json => params
		return
	end

	def profile
		if params[:id]
			@user = User.find(params[:id])
			if session[:user_id] != nil
				@friends = Friend.where('user_id = ? AND is_accept = ?',params[:id], 1)
				# render :json => @friends
				# return
				if session[:user_id].to_i == params[:id].to_i
					@friendsRequest = Friend.where('user_friend_id = ? AND is_accept = ?', session[:user_id], 0)
				end
				@favorites = Friend.where('user_id = ? AND is_favorite = ?', params[:id], 1)
			end
		else
			redirect_to root_path
		end
	end

	private
	  def user_params
	    params.require(:user).permit(:first_name, :last_name, :email, :password, :address, :phone)
	  end
end
