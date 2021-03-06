Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

	root 'static_pages#home'
	
	#static_pages
  get '/help', 		to: 'static_pages#help'
	get '/about',		to: 'static_pages#about'
	get '/contact',	to: 'static_pages#contact'
	
	#users
  get '/signup', 	to: 'users#new'
	post '/signup', to: 'users#create'
	resources :users do
		member do
			get :following, :followers
		end
	end
	
	#sessions
	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
	
	#account activations
	resources :account_activations, only: [:edit]

	#password resets
	resources :password_resets, only: [:new, :create, :edit, :update]

	#microposts
	resources :microposts, only:[:create, :destroy]

	#relationships
	resources :relationships, only: [:create, :destroy]
	
end

