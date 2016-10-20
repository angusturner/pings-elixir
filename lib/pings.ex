defmodule Pings do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Pings.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Pings.Endpoint, []),
      # Start your own worker by calling: Pings.Worker.start_link(arg1, arg2, arg3)
      # worker(Pings.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pings.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Pings.Endpoint.config_change(changed, removed)
    :ok
  end
end
