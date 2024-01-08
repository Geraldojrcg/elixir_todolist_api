defmodule TodolistWeb.Router do
  use TodolistWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :maybe_browser_auth do
    plug(
      Guardian.Plug.Pipeline,
      error_handler: TodolistWeb.AuthController,
      module: TodolistWeb.Guardian
    )
    plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  pipeline :ensure_authed_access do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", TodolistWeb do
    pipe_through :api

    post "/auth/login", AuthController, :create
    post "/auth/register", AuthController, :register

  end

  scope "/api", TodolistWeb do
    pipe_through [:api, :maybe_browser_auth, :ensure_authed_access]

    resources "/users", UserController
    resources "/todos", TodoController
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:todolist, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TodolistWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
