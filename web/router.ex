defmodule Pings.Router do
  use Pings.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pings do
    pipe_through :api

    post "/:device_id/:time", PageController, :add_ping

    get "/all/:date", PageController, :all_date

    get "/all/:from/:to", PageController, :all_range

    get "/:device_id/:date", PageController, :single_date

    get "/:device_id/:from/:to", PageController, :single_range

    get "/devices", PageController, :list_devices

    post "/clear_data", PageController, :clear_data

    get "/", PageController, :index
  end
end
