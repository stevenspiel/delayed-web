Delayed::Web::Engine.routes.draw do
  root to: 'jobs#queued'

  resources :jobs, only: [:destroy, :show] do
    get :queued, on: :collection
    get :scheduled_email, on: :collection
    put :queue, on: :member
  end
end
