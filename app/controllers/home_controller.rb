class HomeController < ApplicationController
	before_action :require_user, only: []
	def index
		
	end
end
