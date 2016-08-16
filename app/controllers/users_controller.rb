class UsersController < ApplicationController
	before_action :require_user, only: [:index]


	def signup
		if request.request_method() == 'POST'
			@user = User.new(user_params)
		     if @user.save
		     	flash[:message_success] = "Register is successful."
				redirect_to signin_path()
			else
				flash[:message_error] = "Register isn't successful"
				render :layout => false
		    end
		else
			@user = User.new
			render :layout => false
		end
		# @user = User.new
	end

	def signin
	  	if request.request_method() == 'POST'
			@user = User.find_by_email(params[:session][:email])
		  	if User.authenticate(params[:session][:email], params[:session][:password])
		    	session[:user_id] = @user.id
		    	redirect_to root_path
		  	else
		  		flash[:message_error] = "Login fail"
		    	redirect_to signin_path()
		  	end 
		else 
			render :layout => false
		end
	end

	def logout
		session[:user_id] = nil
		flash[:message_success] = "Logout is successful"
		redirect_to signin_path()
	end

	def find_friend
		if params[:query]
			query = params[:query]
			@users = User.search(query)
			response = []
			@users.each { |item|
				response << {'id' => item.id, 'name' => item.first_name, 'url' => 'abbccb'}
			}
			render :json	 => response
			# return
		end
	end

	def list_friends
		if session[:user_id] != nil
			@users = User.where('id <> ?', session[:user_id]).page(params[:page])
		else
			@users = User.all.page(params[:page])
		end
	end

	def add_friend
		if params[:id]
			user = User.find(params[:id])
			if !user.nil? && session[:user_id]
				friend = Friend.where('(user_id = ? AND user_friend_id = ?) OR (user_id = ? AND user_friend_id = ?)', session[:user_id], user.id, user.id, session[:user_id]).first
				if friend.nil?
					friend = Friend.new(:user_id => session[:user_id], :user_friend_id => user.id, :is_accept => 0)
					if friend.save
						render :json => {status: 1, message: "Add friend is successful."}
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

	def accept_friend
		if params[:id]
			friend = Friend.find(params[:id])
			if !friend.nil?
				if friend.is_accept == 0
					if friend.update_column(:is_accept, 1)
						friend2 = Friend.new(:user_id => friend.user_friend_id, :user_friend_id => friend.user_id, :is_accept => 1)
						if friend2.save
							render :json => {status: 1, message: "Successful."}
						end
					else
						render :json => {status: 0, message: "Don't Successful."}
					end
				end
			end
		end
	end

	def remove_friend
		if params[:id]
			user = User.find(params[:id])
			if !user.nil? && session[:user_id]
				friend = Friend.where('(user_id = ? AND user_friend_id = ?) OR (user_id = ? AND user_friend_id = ?)', session[:user_id], user.id, user.id, session[:user_id]).first
				if !friend.nil?
					friend.destroy
					render :json => {status: 1, message: "Remove friend is successful."}
				end
			else
				render :json => {status: 0, message: "Not found this friend."}
			end
		else
			render :json => {status: 0, message: "Not found this friend."}
		end
		return
	end

	def add_friend_favorite
		if params[:id]
			user = User.find(params[:id])
			if !user.nil? && session[:user_id]
				friend = Friend.where('user_id = ? AND user_friend_id = ?', session[:user_id], user.id).first
				# render :json =>friend
				# return
				if friend.nil?
					friend = Friend.new(:user_id => session[:user_id], :user_friend_id => user.id, :is_favorite => 1)
					if friend.save
						me = User.find(session[:user_id])
						if !me.nil?
							me.points +=1
							me.save
						end
						render :json => {status: 1, message: "Add to friend favorite is successful."}
					end
				else
					if friend.update_column( :is_favorite, 1)
						me = User.find(session[:user_id])
						if !me.nil?
							me.points +=1
							me.save
						end
					end
					render :json => {status: 1, message: "Add to friend favorite is successful."}
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
				@friends = Friend.where('(user_friend_id = ? OR user_id = ?) AND is_accept = ?', params[:id], params[:id], 1)
				render :json => @friends
				return
				if session[:user_id].to_i == params[:id].to_i
					@friendsRequest = Friend.where('user_friend_id = ? AND is_invite = ?', session[:user_id], 0)
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
