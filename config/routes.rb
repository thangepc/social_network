Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root to: 'home#index'
  match '/register', to: 'users#signup', via: [:get, :post], as: :signup
  match '/signin', to: 'users#signin', via: [:get, :post], as: :signin
  get '/logout', to: 'users#logout', as: :logout
  get '/find-friends', to: 'users#find_friend', as: :find_friend
  get '/friends', to: 'users#list_friends', as: :friends
  post '/add-friend', to: 'users#add_friend', as: :add_friend
  post '/remove-friend', to: 'users#remove_friend', as: :remove_friend
  post '/add-friend-favorite', to: 'users#add_friend_favorite', as: :add_friend_favorite
  post '/invite-friend', to: 'users#invite_friend', as: :invite_friend

  get '/profile/:id', to: 'users#profile', as: :profile
  # post '/add-friend'
end
