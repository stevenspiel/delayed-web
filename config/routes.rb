Delayed::Web::Engine.routes.draw do
  root to: 'jobs#queued'

  resources :jobs, only: [:destroy, :show] do
    get :queued, on: :collection
    get :scheduled_email, on: :collection
    get :health_check, on: :collection
    get :health_check_tasks, on: :collection
    put :queue, on: :member
  end
end
