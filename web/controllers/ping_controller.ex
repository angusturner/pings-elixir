defmodule Pings.PageController do
  use Pings.Web, :controller
  alias Pings.Ping

  def index(conn, _params) do
    render conn, data: %{message: "nothing here"}
  end

  def single_date(conn, params) do
    render conn, data: Ping.single_date(params)
  end

  def single_range(conn, params) do
    render conn, data: Ping.single_range(params)
  end

  def all_date(conn, params) do
    render conn, data: Ping.all_date(params)
  end

  def all_range(conn, params) do
    render conn, data: Ping.all_range(params)
  end

  def list_devices(conn, _params) do
    render conn, data: Ping.fetch_devices()
  end

  def clear_data(conn, _params) do
    render conn, data: Ping.clear_data()
  end

  def add_ping(conn, params) do
    render conn, data: Ping.insert(params)
  end

end
