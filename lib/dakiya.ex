defmodule Dakiya do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
     {Plug.Adapters.Cowboy2, scheme: :http, plug: Dakiya.Router, options: [port: 8080]}
    ]

    Logger.info("Started application")

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
