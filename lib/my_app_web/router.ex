defmodule MyAppWeb.Router do
  use MyAppWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug MyAppWeb.EnsureRolePlug, [:admin, :super_admin]
  end

  pipeline :super_admin do
    plug MyAppWeb.EnsureRolePlug, :super_admin
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyAppWeb do
  #   pipe_through :api
  # end

  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:browser, :admin]

    live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
