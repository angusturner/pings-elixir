defmodule Pings.Ping do
  use Pings.Web, :model
  alias Pings.Repo
  alias Pings.Ping

  # define the table schema
  schema "pings" do
    field :device_id, :string
    field :time, Ecto.DateTime
  end

  # use a changeset to validate insert statements
  def changeset(ping, params \\ %{}) do
    ping
    |> cast(params, [:device_id, :time])
    |> validate_required([:device_id, :time])
  end

  # insert a new ping
  def insert(%{"device_id" => device_id, "time" => time}) do
    ping = %{device_id: device_id, time: to_timex(time)}
    Repo.insert(changeset(%Ping{}, ping))
    %{response: "OK"}
  end

  # fetch all entries for a single device on the specified date
  def single_date(%{"device_id" => device_id, "date" => date}) do
    {lower, upper} = date_to_range(date)
    single_device(device_id, lower, upper)
  end

  # fetch all entries for a single device in the specified range
  def single_range(%{"device_id" => device_id, "from" => from, "to" => to}) do
    [lower, upper] = [from, to] |> Enum.map(&to_timex/1)
    single_device(device_id, lower, upper)
  end

  # return all pings for a given device, between lower and upper
  defp single_device(device_id, lower, upper) do
    query = from p in Ping,
      where: p.device_id == ^device_id and p.time >= ^lower and p.time < ^upper,
      select: p.time

    query
    |> Repo.all
    |> Enum.map(&ecto_to_utc/1)
  end

  # fetch all pings on a particular date
  def all_date(%{"date" => date}) do
    {lower, upper} = date_to_range(date)
    all_devices(lower, upper)
  end

  # fetch all pings in the specified range
  def all_range(%{"from" => from, "to" => to}) do
    [lower, upper] = [from, to] |> Enum.map(&to_timex/1)
    all_devices(lower, upper)
  end

  # return all pings (all devices) between lower and upper
  defp all_devices(lower, upper) do
    query = from p in Ping,
      where: p.time >= ^lower and p.time < ^upper,
      select: {p.device_id, p.time}

    query
    |> Repo.all
    |> Enum.map(fn {id, time} ->
      %{id: id, time: ecto_to_utc(time)}
    end)
    |> Enum.reduce(%{}, fn (%{id: id, time: time}, acc) ->
      case Map.has_key?(acc, id) do
        true -> %{acc | id => acc[id] ++ [time]}
        false -> Map.put(acc, id, [time])
      end
    end)
  end

  # fetch all devices
  def fetch_devices do
    query = from p in Ping,
      group_by: [:device_id],
      select: p.device_id

    Repo.all(query)
  end

  # clear all entries
  def clear_data do
    Repo.delete_all(Ping)
    %{result: "OK"}
  end

  ### Helper Functions for Date Manipulation ###
  
  # convert an ISO Date to a 24hr interval defined by two Timex.DateTime structs
  defp date_to_range(date) do
    lower = to_timex(date)
    upper = Timex.shift(lower, [days: 1])
    {lower, upper}
  end

  # convert a stored DB time back to UTC
  defp ecto_to_utc(time) do
    time
    |> Ecto.DateTime.cast!
    |> Ecto.DateTime.to_string
    |> Timex.parse!("{YYYY}-{0M}-{0D} {h24}:{m}:{s}")
    |> Timex.format!("{s-epoch}")
  end

  # convert ISO and UTC supplied dates to Timex.DateTime structs
  defp to_timex(date) do
    # try parsing as ISO Date, else default to UTC (seconds)
    case Timex.parse(date, "{YYYY}-{0M}-{0D}") do
      {:ok, date} -> date
      _ -> Timex.parse!(date, "{s-epoch}")
    end
  end

end
