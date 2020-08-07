defmodule MikkelDieren.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MikkelDieren.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: MikkelDieren.PubSub}
      # Start a worker by calling: MikkelDieren.Worker.start_link(arg)
      # {MikkelDieren.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MikkelDieren.Supervisor)
  end
end
