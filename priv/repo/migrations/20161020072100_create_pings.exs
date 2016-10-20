defmodule Pings.Repo.Migrations.CreatePings do
  use Ecto.Migration

  def change do
    create table(:pings) do
      add :device_id, :string
      add :time, :timestamp
    end
  end
end
