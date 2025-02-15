Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :trips do
    get 'add-companion', to: 'companions#add_field'
    resources :companions, only: %i[show new create]
    resources :activites
    resources :flights
    resources :accommodations
    member do
      get 'activities/new', to: 'trips#activities'
    end
    resources :attractions, only: [:create]
    resources :restaurants, only: [:create]
    get "loading/", to: "pages#loading", as: :loading_page
    get "trip-generate/", to: "pages#generate", as: :generate_page
  end

  resources :chats, only: %i[index show] do
    resources :messages, only: :create
  end

  #get "pages/", to: "pages#generate", as: :generate_page

  get "dashboard", to: "pages#dashboard", as: :dashboard_page do
    get "trips/show", to: "trips#show"
  end

  get "pages/flip-card-back", to: "pages#flip-card-back"
  get "pages/profile", to: "pages#profile", as: :profile_page
end
