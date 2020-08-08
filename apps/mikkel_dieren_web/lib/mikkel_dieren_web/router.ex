defmodule MikkelDierenWeb.Router do
  use MikkelDierenWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MikkelDierenWeb.Plugs.Locale
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug MikkelDierenWeb.Plugs.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug MikkelDierenWeb.Plugs.Authenticate
  end

  pipeline :auth do
    plug MikkelDierenWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :allowed_for_users do
    plug MikkelDierenWeb.Plugs.AuthorizationPlug, ["Admin", "Manager", "User"]
  end

  pipeline :allowed_for_managers do
    plug MikkelDierenWeb.Plugs.AuthorizationPlug, ["Admin", "Manager"]
  end

  pipeline :allowed_for_admins do
    plug MikkelDierenWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  scope "/", MikkelDierenWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    resources "/registrations", EditController, only: [:new, :create]
  end

  scope "/", MikkelDierenWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users, :with_session]

    get "/user_scope", PageController, :user_index
    get "/profile/:id", EditController, :index
    get "/profile/edit/username/:id", EditController, :edit_username
    get "/profile/edit/password/:id", EditController, :edit_password
    put "/profile/edit/username/:id", EditController, :update_username
    put "/profile/edit/password/:id", EditController, :update_password
    get "/profile/token/:id", TokenController, :token
    get "/profile/token/show/:id", TokenController, :show
    delete "/profile/token/:id", TokenController, :delete
    post "/profile/token/:id", EditController, :generate_api_token
  end

  scope "/admin", MikkelDierenWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins, :with_session]

    resources "/users", UserController
    get "/", PageController, :admin_index
  end

  scope "/api", MikkelDierenWeb do
    pipe_through :api

    resources "/users", UserController, only: [] do
      resources "/animals", AnimalController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MikkelDierenWeb do
  #   pipe_through :api
  # end
end
